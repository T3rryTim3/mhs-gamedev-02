extends Humanoid
class_name Player

@onready var collector:Collector = $Collector
@onready var collector_collider:CollisionShape2D = $Collector/PickupRange/CollisionShape2D
@onready var use_bar = $TextureProgressBar
@onready var high_temp_particles:GPUParticles2D = $HighTempParticles
@onready var camera:Camera2D = $Camera2D

signal give_upgrade
signal upgrade_added
signal mode_changed
signal death
signal item_used

var blueprint_hover = preload("res://scenes/Base/blueprint_hover.tscn")

enum ThirstLevel {
	NONE,
	LOW,
	MEDIUM,
	HIGH
}

#region Exports
## Area2D that the camera is restricted to
@export var camera_limit:CollisionShape2D

## Cooldown before sprinting starts to recover
@export var sprint_cooldown:float = 1.3

## Sprint speed (Multiplier)
@export var sprint_speed:float = 1.5

## The farthest that the player can drop items
@export var max_drop_distance:float = 50

## Stamina per second drained while sprining
@export var stamina_drain:float = 20

## Stamina per second gained after sprint ended
@export var stamina_gain:float = 30

## Station shader for selection
@onready var station_shader = load("res://Resources/station_select_shader.tres")

## Color gradient based on player temp
@onready var temp_color = load("res://Resources/player_temp_color.tres")
#endregion

#region Other Vars
## Camera offset from the mouse position
var camera_mouse_offset:Vector2

## Current upgrades
var upgrades = {}

## Stamina bar
var stamina_bar:StatBar

## Blueprint overlay
var blueprint_overlay:Control

## Current cooldown for hiding/showing stamina bar
var stamina_show_cooldown:float = 0

## Change per second of stamina bar alpha
var stamina_show_delta:float = 0

## Current blueprint hover object
var current_blueprint:BlueprintHover

## Current item drop display
var current_item_display:Sprite2D

## Currently sprinting
var sprinting:bool = false

## Current sprint cooldown value (Before stamina recovery)
var current_sprint_cooldown:float = 0.0

## If the player is currently in delete move
var delete_mode:bool = false

## Time until next hunger damage tick
var hunger_tick:float = 2.5

## Damage per hunger tick
var hunger_damage:float = 1

## Whether or not the player is still alive
var alive = true

## An array of the currently selected blueprints. This is used to determine the item hover visibility
var hovered_blueprints:Array

## An array of currently hovered items. This should only be at one time at a time.
var hovered_items:Array

var hunger_tick_max:float
#endregion

#region Stats
func _get_thirst_level() -> ThirstLevel:
	var perc = state.thirst.val / state.thirst.max
	if perc <= 0.5:
		return ThirstLevel.NONE
	elif perc <= 0.3:
		return ThirstLevel.LOW
	elif perc <= 0.1:
		return ThirstLevel.MEDIUM
	return ThirstLevel.HIGH

func _is_thirsty() -> bool: ## Returns true if thirst is above a certain threshold
	return state.thirst.val < Config.THIRST_STAMINA_THRESHHOLD

func _is_exhausted() -> bool: ## Returns true if temp is above a certain threshold
	return state.temp.val / state.temp.val_max > Config.HIGH_TEMP_THRESHOLD

func _is_freezing() -> bool:
	return state.temp.val / state.temp.val_max < Config.LOW_TEMP_THRESHOLD

#region upgrades
func add_upgrade(upgrade = Upgrades.Upgrade) -> void: ## Give the player an upgrade
	if not (upgrade in upgrades):
		upgrades[upgrade] = 1
	else:
		upgrades[upgrade] += 1

	state.hunger.val_max = Config.MAX_HUNGER + _get_upgrade(Upgrades.Upgrades.HUNGER) * Config.HUNGER_UPGRADE_INCREASE
	state.thirst.val_max = Config.MAX_THIRST + _get_upgrade(Upgrades.Upgrades.THIRST) * Config.THIRST_UPGRADE_INCREASE
	#state.stamina.val_max = Config.MAX_STAMINA + _get_upgrade(Upgrades.Upgrades.STAMINA) * Config.STAMINA_UPGRADE_INCREASE
	upgrade_added.emit()

func _get_upgrade(upgrade = Upgrades.Upgrades) -> int: ## Returns the upgrade count of the passed upgrade
	if upgrade in upgrades:
		return upgrades[upgrade]
	else:
		return 0
#endregion

func _update_stats(delta:float): # Updates the player's stats with respect to time
	if not alive:
		move_speed = 0
		return
	_get_level().player_stat_update(self, delta) # Apply level effects

	#state["hunger"].val -= (0.6 + int(sprinting) * 0.5) * delta # Default hunger drain
	#state["thirst"].val -= (1 + int(sprinting) * 0.5) * delta # Default thirst drain
	#state.temp.val += int(sprinting) * 0.5 * delta # Heat if sprinting

	state.hunger.set_drain_factor('sprint', sprinting)
	state.thirst.set_drain_factor('sprint', sprinting)
	state.temp.set_drain_factor('sprint', sprinting)

	state.thirst.set_drain_factor('high_temp', _is_exhausted())
	state.stamina.set_drain_factor('high_temp', _is_exhausted())
	high_temp_particles.emitting = _is_exhausted()
	
	sprite.self_modulate *= temp_color.gradient.sample(state.temp.val / state.temp.val_max)
	
	# Movement speed
	var speed_totem_count = _get_level().get_station_count(StationData.Stations.SPEED_TOTEM)
	var speed_increase = Config.SPEED_TOTEM_INCREASE * speed_totem_count
	speed_increase += Config.SPEED_UPGRADE_INCREASE * _get_upgrade(Upgrades.Upgrades.SPEED)
	move_speed = Config.PLAYER_BASE_MOVE_SPEED + speed_increase
	if _is_exhausted():
		move_speed -= Config.HIGH_TEMP_SPEED_FACTOR
	elif _is_freezing():
		move_speed -= Config.LOW_TEMP_SPEED_FACTOR

	# Begin cooldown if not started
	if sprinting:
		current_sprint_cooldown = sprint_cooldown
		var upgrade_mult = pow(0.8, _get_upgrade(Upgrades.Upgrades.STAMINA))
		state.stamina.val -= stamina_drain * delta * (int(_is_exhausted()) + 1) * upgrade_mult
	if current_sprint_cooldown <= 0:
		if !_is_thirsty():
			state.stamina.val += stamina_gain * delta
	else:
		current_sprint_cooldown -= delta
 
#endregion

#region Blueprints
func begin_blueprint(station:StationData.Stations):
	if current_blueprint:
		current_blueprint.queue_free()

	current_blueprint = blueprint_hover.instantiate()
	current_blueprint.station = station

	add_child(current_blueprint)
	#current_blueprint.sprite.texture = load(StationData.get_station_texture(station))
	current_blueprint._update_sprite(station)

	# Set station shaders to visualize selection
	station_shader.set_shader_parameter("active", true)

	_update_blueprint_sprite(blueprint_overlay.stations[blueprint_overlay.current_index])

	blueprint_overlay.visible = true

func stop_blueprint():
	current_blueprint.queue_free()
	current_blueprint = null
	station_shader.set_shader_parameter("active", false)
	blueprint_overlay.visible = false
#endregion

#region Items
func _use(delta) -> bool: # Use the topmost held item. Returns true if done successfully
	var item = collector.get_topmost_item()
	if not item:
		return false
	if not item.use_stream.playing:
		item.use_stream.play()
	ItemData.use_item(item, self, delta)
	return true

func _used_item() -> Item: # Gets the currently being used item, if any
	var item = collector.get_topmost_item()
	if item and item.using:
		return item
	return null

func update_collector_stack_lim():
	collector.stack_limit = _get_level().get_station_count(StationData.Stations.STRENGTH_TOTEM)+Config.PLAYER_BASE_ITEM_LIMIT+_get_upgrade(Upgrades.Upgrades.STRENGTH)

func highlight_nearest(): ## Highlight the nearest item
	var nearest:Item = null
	nearest = collector._get_nearest_item(false, -1, get_global_mouse_position())
	if nearest:
		if len(collector.current_resources) < collector.stack_limit:
			nearest.enable_outline()
			if not (nearest in hovered_items):
				hovered_items.append(nearest)
		else:
			nearest.disable_outline()
			hovered_items.erase(nearest)
	for x in collector.pickup_area.get_overlapping_bodies():
		if x is Item and not (x == nearest):
			x.disable_outline()
			hovered_items.erase(x)

func _on_pickup_range_body_exited(body: Node2D) -> void:
	if body is Item:
		body.disable_outline()

func _update_blueprint_sprite(new):
	if current_blueprint:
		current_blueprint.station = new
#endregion

func _ready():
	super()
	Globals.player = self
	dam_sound.stream = load("res://Audio/SFX/Other/hurt.wav") # Replace damage sound
	dam_sound.volume_db -= 1

	update_collector_stack_lim()

	await _get_level().ready # Ensures UI is fully loaded

	## Apply respective map particles
	match Globals.current_level:
		Main.Scenes.LEVEL_FIELD:
			$MapParticles/Leaves.visible = true
		Main.Scenes.LEVEL_TUNDRA:
			$MapParticles/Snow.visible = true

	if camera_limit: # Prevent camera from going beyond area
		$Camera2D.limit_bottom = camera_limit.global_position.y + camera_limit.shape.get_rect().size.y/2
		$Camera2D.limit_top = camera_limit.global_position.y - camera_limit.shape.get_rect().size.y/2
		$Camera2D.limit_left = camera_limit.global_position.x - camera_limit.shape.get_rect().size.x/2
		$Camera2D.limit_right = camera_limit.global_position.x + camera_limit.shape.get_rect().size.x/2

		var sprite_texture = get_sprite_texture()

		# Instantiate stamina bar
		stamina_bar = stat_bar.instantiate()
		stamina_bar.texture_width = sprite_texture.get_width() * sprite.scale.x
		stamina_bar.texture_height = sprite_texture.get_height() * sprite.scale.y * 0.6

		stamina_bar.thickness = 0.1

		stamina_bar.position.y = (sprite_texture.get_height()/2.0)*sprite.scale.y + stamina_bar.thickness + 4
		stamina_bar.position += health_bar_offset

		stamina_bar.size_scale = health_bar_scale * 0.8
		
		stamina_bar.texture_progress = load("res://Resources/stamina_progress.tres")
		
		hunger_tick_max = hunger_tick

		add_child(stamina_bar)

		use_bar.visible = false

	# Blueprint overlay
	blueprint_overlay = load("res://scenes/UI/blueprint_menu.tscn").instantiate()
	_get_level().ui_layer.add_child.call_deferred(blueprint_overlay)
	blueprint_overlay.visible = false
	blueprint_overlay.new_station.connect(_update_blueprint_sprite)

	var l_data = _get_level().level_data
	# Create stats
	state["hunger"] = StateItem.new(100, 0, 100, Config.DRAIN_HUNGER * l_data.hunger_multi,
		[
			DrainFactor.new("sprint", 0.5, DrainFactorTypes.ADD, false),
		]
	)
	state["thirst"] = StateItem.new(100, 0, 100, Config.DRAIN_THIRST * l_data.thirst_multi,
		[
			DrainFactor.new("sprint", 0.5, DrainFactorTypes.ADD, false),
			DrainFactor.new("high_temp", 1, DrainFactorTypes.ADD)
		]
	)
	state["temp"] = StateItem.new(50, 0, 100, 0, # Manually drained through level
		[
			DrainFactor.new("sprint", -0.5, DrainFactorTypes.ADD, false),
			DrainFactor.new("campfire", -6, DrainFactorTypes.ADD, false)
		]
	)
	state["stamina"] = StateItem.new(100, 0, 100, 0, 
		[
			DrainFactor.new("high_temp", 5, DrainFactorTypes.ADD, false)
		]
	)

	#add_effect(EffectData.EffectTypes.WEATHER_COLD, 100, 10)

func _attack():
	if not super(): # Return if attack is in progress already
		return
	$Swing.play(0.39)
	for body in $HitCollider.get_overlapping_bodies():
		if body.has_method("player_hit"):
			body.player_hit()
	#for area in $HitCollider.get_overlapping_areas():
		#print(area)

	# Rock breaking
	var level:Level = _get_level()
	if level.break_layer:
		var pos = level.break_layer.local_to_map(level.break_layer.to_local($HitCollider.global_position))
		var data = level.break_layer.get_cell_tile_data(pos)
		if data:
			level.break_layer.set_cell(pos, -1)
		else:
			for pos_1 in level.break_layer.get_surrounding_cells(pos):
				var data_1 = level.break_layer.get_cell_tile_data(pos_1)
				if data_1:
					level.break_layer.set_cell(pos_1, -1)
					break

func _process(delta) -> void:
	super(delta)

	if EventMan.is_event(EventMan.Events.STORM):
		$MapParticles/Rain.emitting = true
		$MapParticles/Rain.visible = true
		$MapParticles/Rain.modulate.a = min(1, $MapParticles/Rain.modulate.a + delta * 0.5)
	else:
		$MapParticles/Rain.emitting = false
		$MapParticles/Rain.modulate.a = 0

	if EventMan.is_event(EventMan.Events.BLIZZARD):
		$MapParticles/Snow2.emitting = true
		$MapParticles/Snow2.visible = true
		$MapParticles/Snow2.modulate.a = min(1, $MapParticles/Snow2.modulate.a + delta * 0.1)
	else:
		$MapParticles/Snow2.emitting = false
		$MapParticles/Snow2.modulate.a = 0

	# Update blueprint
	if current_blueprint:
		if Input.is_action_pressed("unsnap_blueprint"):
			current_blueprint.global_position = get_global_mouse_position()
		else:
			current_blueprint.global_position = _round_vector(get_global_mouse_position(), 12)
		current_blueprint.update()

	stamina_bar.current = state.stamina.val/state.stamina.val_max
	stamina_bar.modulate.a = clampf(stamina_bar.modulate.a + stamina_show_delta, 0, 1)

	# Handle stamina bar visibility
	if current_sprint_cooldown <= 0:
		if stamina_bar.modulate.a >= 1:
			if stamina_show_cooldown <= 0:
				stamina_show_cooldown = 1
		stamina_show_cooldown -= delta
		if stamina_show_cooldown <= 0:
			stamina_show_delta = -0.1
	else:
		stamina_show_delta = 0.1
	
	if self.state.hunger.val <= 0:
		if hunger_tick <= 0:
			damage(hunger_damage)
			hunger_tick = hunger_tick_max
		hunger_tick -= delta

	# Item hover
	highlight_nearest()
	
	# Input
	var dir = global_position.direction_to(get_global_mouse_position())
	var distance = min(global_position.distance_to(get_global_mouse_position()), max_drop_distance)
	collector.search_range.global_position = (dir*distance + global_position)
	if Input.is_action_just_pressed("pickup"):
		update_collector_stack_lim()
		if not collector.add_nearest_item(-1, get_global_mouse_position()):
			collector.drop_item(dir*distance + global_position)
		if len(collector.current_resources) >= 3:
			Achievements.raise_progress(Achievements.Achievements.STRONGMAN)
	
	elif Input.is_action_just_pressed("drop"):
		collector.search_range.global_position = (dir*distance + global_position)
		collector.drop_item(dir*distance + global_position)

	# Move hit collider
	var rad = $HitCollider/HitCollider.shape.radius
	var ang = global_position.direction_to(get_global_mouse_position()).angle()
	$HitCollider.position = Vector2(rad*cos(ang),rad*sin(ang)) # Aim towards the mouse

	# Update item progress
	var item = _used_item()
	if Input.is_action_pressed("use_item"):
		if not _use(delta) and Input.is_action_just_pressed("attack"): # Prevent holding attack
			_attack()
	elif item:
		item.using = false

	if item and item.using:
		use_bar.show()
		use_bar.value = (item.item_usage_progress / item.item_usage_max) * use_bar.max_value
	else:
		use_bar.hide()

	# Show item overlay
	if len(collector.current_resources) > 0 and not current_blueprint:
		if current_item_display and current_item_display.get_meta("item") != collector.get_topmost_item().id:
			current_item_display.queue_free()
		elif current_item_display and len(hovered_blueprints) > 0:
			current_item_display.hide()
		elif current_item_display:
			current_item_display.show()

		if not current_item_display:
			var img = ItemData.get_item_data(collector.get_topmost_item().id)["img_path"]

			current_item_display = Sprite2D.new()
			current_item_display.texture = load(img)
			current_item_display.modulate.a = 0.5
			current_item_display.set_meta("item", collector.get_topmost_item().id)

			add_child(current_item_display)

		var item_dir = global_position.direction_to(get_global_mouse_position())
		var item_distance = min(global_position.distance_to(get_global_mouse_position()), max_drop_distance)
		current_item_display.global_position = item_dir * item_distance + global_position
	else:
		if current_item_display:
			current_item_display.queue_free()

	_update_stats(delta)

func _input(event) -> void:

	if event.is_action_pressed("remove_station"):
		if not delete_mode:
			if current_blueprint:
				stop_blueprint()
			delete_mode = true
		else:
			delete_mode = false
		mode_changed.emit()
	
	if event.is_action_pressed("blueprint"):
		if current_blueprint:
			stop_blueprint()
		else:
			if delete_mode:
				delete_mode = false
			begin_blueprint(StationData.Stations.WELL)
		mode_changed.emit()

	if event is InputEventKey:
		if event.pressed:
			match event.keycode:
				KEY_K:
					#EventMan.spawn_event(EventMan.Events.TORNADO, get_parent(), 1)
					#EventMan.spawn_event(EventMan.Events.VOLCANO, get_parent(), 1)
					EventMan.spawn_event(EventMan.Events.STORM, get_parent(), 1)
					#EventMan.spawn_event(EventMan.Events.BLIZZARD, get_parent(), 1)
					#EventMan.spawn_event(EventMan.Events.EARTHQUAKE, get_parent(), 1)
				KEY_N:
					print("--- Player Stats ---")
					print("Thirst:")
					print(state.thirst.val)
					print("Hunger:")
					print(state["hunger"].val)
					print("Temp:")
					print(state["temp"].val)
				KEY_R:
					collector.cycle_items()
				KEY_P:
					give_upgrade.emit()
				KEY_7:
					_update_health(0)

	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and current_blueprint:
			if current_blueprint.valid:
				current_blueprint.place(get_parent())
				stop_blueprint()
				mode_changed.emit()

	holding_item = len(collector.current_resources) > 0

func damage(amount:float) -> void: # Deal damage to the entity
	amount *= _get_level().level_data.damage_multi # Increase damage based on leveldata
	amount *= pow(0.9, _get_upgrade(Upgrades.Upgrades.TOUGH))
	camera.add_trauma(amount / max_health)
	super(amount)

func _death():
	if not alive:
		return
	Achievements.raise_progress(Achievements.Achievements.ILL_BE_BACK, 1)
	Achievements.raise_progress(Achievements.Achievements.HUNDRED_DEATHS, 1)
	death.emit()
	alive = false
	$DeathSound.play()
	hide()

func _movement(delta) -> void:
	super(delta)
	move_dir = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	
	# Check for sprinting input
	if Input.is_action_pressed("sprint") and state.stamina.val > 0 and move_dir != Vector2.ZERO:
		sprinting = true
	else:
		sprinting = false

	if move_dir != Vector2.ZERO:
		last_move_dir = move_dir

	# Account for sprint
	var speed = move_speed
	if sprinting:
		speed *= sprint_speed

	velocity += speed * move_dir.normalized()
	
	var collector_pos_dir:Vector2 = last_move_dir
	if collector_pos_dir.x != 0:
		collector_pos_dir.y = 0

	collector.position = collector_pos_dir * (collector_collider.shape.get_rect().size.x/4)
	#collector.pickup_area.global_position = camera_mouse_offset
	#collector.position = camera_mouse_offset
	collector.drop_pos_node.position = collector.position

	# Account for animation bounce
	collector.position.y += sprite.frame % 2
	if velocity == Vector2.ZERO:
		collector.position.y += 1

	if collector_pos_dir.y <= 0:
		collector.z_index = -1
	else:
		collector.z_index = 1
		collector.position.y -= 8

	# Footsteps
	if velocity != Vector2.ZERO:
		$GPUParticles2D.emitting = true
	else:
		$GPUParticles2D.emitting = false

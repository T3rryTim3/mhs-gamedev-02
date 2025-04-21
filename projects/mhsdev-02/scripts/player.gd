extends Humanoid
class_name Player

@onready var collector:Collector = $Collector
@onready var collector_collider:CollisionShape2D = $Collector/PickupRange/CollisionShape2D
@onready var use_bar = $TextureProgressBar
@onready var high_temp_particles:GPUParticles2D = $HighTempParticles

signal give_upgrade
signal mode_changed

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

## Currently sprinting
var sprinting:bool = false

## Current sprint cooldown value (Before stamina recovery)
var current_sprint_cooldown:float = 0.0

## If the player is currently in delete move
var delete_mode:bool = false

## Time until next hunger damage tick
var hunger_tick:float = 1.5

## Damage per hunger tick
var hunger_damage:float = 1

## Whether or not the player is still alive
var alive = true

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
func _use(delta): # Use the topmost held item
	var item = collector.get_topmost_item()
	if not item:
		return
	ItemData.use_item(item, self, delta)

func _used_item() -> Item: # Gets the currently being used item, if any
	var item = collector.get_topmost_item()
	if item and item.using:
		return item
	return null

func update_collector_stack_lim(limit:int):
	collector.stack_limit = limit

func highlight_nearest(): ## Highlight the nearest item
	var nearest:Item = null
	var nearest_distance:float = INF

	# Loop through items
	for x in collector.pickup_area.get_overlapping_bodies():
		var distance = global_position.distance_to(x.global_position)

		if x is Item and distance < nearest_distance:

			# Update if its the closest
			if not (x.get_parent() is Collector):
				if nearest:
					nearest.disable_outline()
				nearest = x
				nearest_distance = distance

		elif x is Item:
			x.disable_outline()

	if nearest:
		if len(collector.current_resources) < collector.stack_limit:
			nearest.enable_outline()
		else:
			nearest.disable_outline()

func _on_pickup_range_body_exited(body: Node2D) -> void:
	if body is Item:
		body.disable_outline()

func _update_blueprint_sprite(new):
	if current_blueprint:
		current_blueprint.station = new
#endregion

func _ready():
	super()

	await _get_level().ready # Ensures UI is fully loaded

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
	blueprint_overlay = load("res://scenes/UI/side_blueprint_overlay.tscn").instantiate()
	_get_level().ui_layer.add_child.call_deferred(blueprint_overlay)
	blueprint_overlay.visible = false
	blueprint_overlay.new_station.connect(_update_blueprint_sprite)

	# Create stats
	state["hunger"] = StateItem.new(100, 0, 100, 0.6,
		[
			DrainFactor.new("sprint", 0.5, DrainFactorTypes.ADD, false),
		]
	)
	state["thirst"] = StateItem.new(100, 0, 100, 0.8,
		[
			DrainFactor.new("sprint", 0.5, DrainFactorTypes.ADD, false),
			DrainFactor.new("high_temp", 1, DrainFactorTypes.ADD)
		]
	)
	state["temp"] = StateItem.new(50, 0, 100, 0, # Manually drained through level
		[
			DrainFactor.new("sprint", -0.5, DrainFactorTypes.ADD, false),
			DrainFactor.new("campfire", -2, DrainFactorTypes.ADD, false)
		]
	)
	state["stamina"] = StateItem.new(100, 0, 100, 0, 
		[
			DrainFactor.new("high_temp", 5, DrainFactorTypes.ADD, false)
		]
	)

	#add_effect(EffectData.EffectTypes.WEATHER_COLD, 100, 10)

func _process(delta) -> void:
	super(delta)

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
	if Input.is_action_just_pressed("pickup"):
		update_collector_stack_lim(
			_get_level().get_station_count(StationData.Stations.STRENGTH_TOTEM)+
			Config.PLAYER_BASE_ITEM_LIMIT+
			_get_upgrade(Upgrades.Upgrades.STRENGTH)
		)
		if not collector.add_nearest_item():
			collector.drop_item()
	
	elif Input.is_action_just_pressed("drop"):
		collector.drop_item()

	# Update item progress
	var item = _used_item()
	if Input.is_action_pressed("use_item"):
		_use(delta)
	elif item:
		item.using = false

	if item and item.using:
		use_bar.show()
		use_bar.value = (item.item_usage_progress / item.item_usage_max) * use_bar.max_value
	else:
		use_bar.hide()

	# Lerp camera
	var distance = min(100, Vector2.ZERO.distance_to(get_local_mouse_position())) / 2
	var offset = Vector2.ZERO.direction_to(get_local_mouse_position())
	$Camera2D.offset = $Camera2D.offset.lerp(offset * distance, 10 * delta)

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

	if event is InputEventKey:
		if event.pressed:
			match event.keycode:
				KEY_B:
					if current_blueprint:
						stop_blueprint()
					else:
						if delete_mode:
							delete_mode = false
						begin_blueprint(StationData.Stations.WELL)
					mode_changed.emit()
				KEY_K:
					EventMan.spawn_event(EventMan.Events.TORNADO, get_parent(), 1)
					EventMan.spawn_event(EventMan.Events.VOLCANO, get_parent(), 1)
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

	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and current_blueprint:
			if current_blueprint.valid:
				current_blueprint.place(get_parent())
				stop_blueprint()
				mode_changed.emit()

	holding_item = len(collector.current_resources) > 0

func _death():
	if not alive:
		return
	alive = false
	$DeathSound.play()
	hide()

func _movement(delta) -> void:
	super(delta)
	move_dir = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	
	# Check for sprinting input
	if Input.is_action_pressed("sprint") and state.stamina.val > 0:
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

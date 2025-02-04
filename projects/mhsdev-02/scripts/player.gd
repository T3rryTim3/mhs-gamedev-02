extends Humanoid
class_name Player

@onready var collector:Collector = $Collector
@onready var collector_collider:CollisionShape2D = $Collector/PickupRange/CollisionShape2D

var blueprint_hover = preload("res://scenes/Base/blueprint_hover.tscn")

## Area2D that the camera is restricted to
@export var camera_limit:CollisionShape2D

## Station shader for selection
@onready var station_shader = load("res://Resources/station_select_shader.tres")

var current_blueprint:BlueprintHover

func _update_stats(delta:float): # Updates the player's stats with respect to time
	_get_level().player_stat_update(self, delta) # Apply level effects
	state["hunger"].val -= 0.6 * delta # Default hunger drain
	state["thirst"].val -= 1 * delta # Default thirst drain

func _ready():
	super()
	if camera_limit: # Prevent camera from going beyond area
		$Camera2D.limit_bottom = camera_limit.global_position.y + camera_limit.shape.get_rect().size.y/2
		$Camera2D.limit_top = camera_limit.global_position.y - camera_limit.shape.get_rect().size.y/2
		$Camera2D.limit_left = camera_limit.global_position.x - camera_limit.shape.get_rect().size.x/2
		$Camera2D.limit_right = camera_limit.global_position.x + camera_limit.shape.get_rect().size.x/2

	state["hunger"] = {
		'val': 100,
		'min': 0,
		'max': 100
	}
	state["thirst"] = {
		'val': 100,
		'min': 0,
		'max': 100
	}
	state["temp"] = {
		'val': 50,
		'min': 0,
		'max': 100
	}

	#add_effect(EffectData.EffectTypes.WEATHER_COLD, 100, 10)

func _death():
	pass

func _movement(delta) -> void:
	super(delta)
	move_dir = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))

	if move_dir != Vector2.ZERO:
		last_move_dir = move_dir

	velocity += move_speed * move_dir.normalized()
	
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

func _process(delta) -> void:
	super(delta)

	# Update blueprint
	if current_blueprint:
		current_blueprint.global_position = _round_vector(get_global_mouse_position(), 24)
		current_blueprint.update()

	_update_stats(delta)

func _use(): # Use the topmost held item
	var item = collector.get_topmost_item()
	if not item:
		return
	ItemData.use_item(item, self)

func _input(event) -> void:
	if event is InputEventKey:
		if event.pressed:
			match event.keycode:
				KEY_E:
					if not collector.add_nearest_item():
						collector.drop_item()
				KEY_Q:
					collector.drop_item()
				KEY_B:
					if current_blueprint:
						stop_blueprint()
					else:
						begin_blueprint(StationData.Stations.WELL)
				KEY_K:
					EventMan.spawn_event(EventMan.Events.TORNADO, get_parent(), 1)
				KEY_N:
					print("--- Player Stats ---")
					print("Thirst:")
					print(state.thirst.val)
					print("Hunger:")
					print(state["hunger"].val)
					print("Temp:")
					print(state["temp"].val)
				KEY_F:
					_use()

	elif event is InputEventMouseButton:
		if current_blueprint:
			if current_blueprint.valid:
				current_blueprint.place(get_parent())
				stop_blueprint()

	holding_item = len(collector.current_resources) > 0

func update_collector_stack_lim(limit:int):
	collector.stack_limit = limit

func begin_blueprint(station:StationData.Stations):
	if current_blueprint:
		current_blueprint.queue_free()

	current_blueprint = blueprint_hover.instantiate()
	current_blueprint.station = station

	add_child(current_blueprint)
	current_blueprint.sprite.texture = load(StationData.get_station_texture(station))

	# Set station shaders to visualize selection
	station_shader.set_shader_parameter("active", true)

func stop_blueprint():
	current_blueprint.queue_free()
	current_blueprint = null
	station_shader.set_shader_parameter("active", false)

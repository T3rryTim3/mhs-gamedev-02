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

func _ready():
	super()
	if camera_limit: # Prevent camera from going beyond area
		$Camera2D.limit_bottom = camera_limit.global_position.y + camera_limit.shape.get_rect().size.y/2
		$Camera2D.limit_top = camera_limit.global_position.y - camera_limit.shape.get_rect().size.y/2
		$Camera2D.limit_left = camera_limit.global_position.x - camera_limit.shape.get_rect().size.x/2
		$Camera2D.limit_right = camera_limit.global_position.x + camera_limit.shape.get_rect().size.x/2

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
		collector.z_index = -2
	else:
		collector.z_index = 1
		collector.position.y -= 8

func _process(delta) -> void:
	super(delta)
	
	# Update blueprint
	if current_blueprint:
		current_blueprint.global_position = _round_vector(get_global_mouse_position(), 24)
		current_blueprint.update()
	
	pass

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

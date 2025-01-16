extends Humanoid
class_name Player

@onready var collector:Collector = $Collector
@onready var collector_collider:CollisionShape2D = $Collector/PickupRange/CollisionShape2D

## Area2D that the camera is restricted to
@export var camera_limit:CollisionShape2D

func _ready():
	super()
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

	holding_item = len(collector.current_resources) > 0

func update_collector_stack_lim(limit:int):
	collector.stack_limit = limit

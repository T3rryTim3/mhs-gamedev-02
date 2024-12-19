extends Humanoid
class_name Player

@onready var collector:Collector = $Collector
@onready var collector_collider:CollisionShape2D = $Collector/PickupRange/CollisionShape2D

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
	if collector_pos_dir.y <= 0:
		collector.z_index = -2
	else:
		collector.z_index = 0

func _process(delta) -> void:
	super(delta)
	pass

func _input(event) -> void:
	if event is InputEventKey:
		if event.pressed:
			match event.keycode:
				KEY_E:
					collector.add_nearest_item()
				KEY_Q:
					collector.drop_item()

	holding_item = len(collector.current_resources) > 0

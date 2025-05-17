extends Event

var shake_delay:float = 5
var shake_power:float = 300
var shake_offset:float = 1

var current_cooldown:float = 0

func _shake() -> void:
	$Shake.play()
	Globals.level.player.camera.add_trauma(0.4)
	for entity in get_tree().get_nodes_in_group("entity"):
		var ang = randf_range(0, 2*PI)
		var dir = Vector2(cos(ang), sin(ang))
		entity.apply_force(dir * shake_power)
		if entity is Station:
			entity._update_health(entity.health - 1.5)
		if entity is Item:
			entity._update_health(entity.max_health * randf_range(0.05,0.15))

func _process(delta:float):
	super(delta)

	current_cooldown += delta
	if current_cooldown >= shake_delay:
		current_cooldown = randf_range(-shake_offset, shake_offset)
		_shake()

	for entity in get_tree().get_nodes_in_group("entity"):
		#entity.global_position += force * (entity.move_influence + 0.01)
		var ang = randf_range(0, 2*PI)
		var dir = Vector2(cos(ang), sin(ang))
		entity.global_position += dir * 0.5

func _ready():
	level = _get_level()

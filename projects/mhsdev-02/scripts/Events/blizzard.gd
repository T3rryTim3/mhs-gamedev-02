extends Event

var push_speed:float = 0
var temp_drain:float = 0

var progress:float = 0
var progress_rate:float = 0.5

var direction:Vector2

#func _get_rand_rot(min:float=0, max:float=2*PI) -> Vector2: # Returns a random direction vector
	#var vec:Vector2
	#var ang = randf_range(0,2*PI)
	#vec = Vector2(cos(ang), sin(ang))
	#
	#return vec

func _process(delta:float):
	super(delta)
	progress += delta

	var force:Vector2 = Vector2.ZERO

	# Vary force over time
	var force_applied = push_speed/2 + (push_speed/2) * abs(sin(progress))

	force = direction * force_applied * min(1, progress/4)

	for entity in get_tree().get_nodes_in_group("entity"):
		entity.global_position += force * (entity.move_influence + 0.01)
		if "temp" in entity.state:
			entity.state.temp.val -= temp_drain * delta
		if entity is Campfire:
			entity.temp -= (entity.temp_gain + (temp_drain * 3)) * delta


func _ready():
	level = _get_level()
	push_speed = 1.5 * (EventMan.scale_val(1) / 2)
	temp_drain = 10 * (EventMan.scale_val(data.strength) / 4)
	#direction = _get_rand_rot(PI/2, (3*PI)/2) # Random angle in quadrant II and III
	direction = Vector2(1,1)

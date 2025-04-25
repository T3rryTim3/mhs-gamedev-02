extends Node
class_name Event

var data:EventMan.EventData
var level:Level

var alive_dur:float = 0

func _log_base(value:float, base:int): ## Takes the log base 'base' of value
	return log(value) / log(base)

func _lerp_vector(start:Vector2, goal:Vector2, n:float):
	return start + (goal - start) * n

func _double_vec2(val:float): ## Returns a vector 2 composed of 'val' twice
	return Vector2(val, val)

func _get_level(): ## Finds the first Level ancestor
	var parent = get_parent() 
	while parent != null:
		if parent is Level:
			return parent
		parent = parent.get_parent()
	return null

func _get_player() -> Player: ## Gets the curent player
	for x in get_tree().get_nodes_in_group("player"):
		return x
	return null

func _process(delta: float) -> void:
	alive_dur += delta
	if alive_dur >= data.duration:
		kill()

func spawn(): ## Called after event spawning
	pass

func kill(): ## Called after event duration
	queue_free()

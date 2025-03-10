extends CanvasLayer
class_name GameUI

var level:Level
var player:Player

func _get_level(): ## Finds the first Level ancestor
	var parent = get_parent() 
	while parent != null:
		if parent is Level:
			return parent
		parent = parent.get_parent()
	return null

func _ready() -> void:
	level = _get_level()
	print("LEVEL")
	await level.ready
	print("LEVEL DONE")
	print(level.player)
	player = level.player

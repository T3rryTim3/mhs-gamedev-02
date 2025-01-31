extends Control

@export var player:Player

func _process(_delta: float) -> void:
	if not player:
		return
	$VBoxContainer/hunger.value = player.state.hunger.val
	$VBoxContainer/thirst.value = player.state.thirst.val
	$VBoxContainer/temp.value = player.state.temp.val

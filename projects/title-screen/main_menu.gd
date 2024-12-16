extends Control


@onready var menu = $smenu

func _on_button_pressed() -> void:
	get_tree().quit()


func _on_button_2_pressed() -> void:
	pass

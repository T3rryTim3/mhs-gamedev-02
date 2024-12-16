extends Control

# Declare button variables
var button1 : Button
var button2 : Button


func _on_button_pressed() -> void:
	get_tree().quit()

extends Control

@onready var you_died = $MarginContainer/AnimatedSprite2D
@onready var title = %Titlescreen

func _ready() -> void:
	visible = false
	



func _on_quit_pressed() -> void:
	visible = false
	title.visible = true
	
	

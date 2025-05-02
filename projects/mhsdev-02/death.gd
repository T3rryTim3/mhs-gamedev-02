extends Control

@onready var you_died = $MarginContainer/AnimatedSprite2D
var player:Player

func display() -> void: ## Display the death screen
	get_tree().paused = true
	$AnimationPlayer.play("Open")
	$MarginContainer/Label.text = Gamestats.get_string()
	if player:
		var minutes = Gamestats.level_time / 60
		var seconds = fmod(Gamestats.level_time, 60)
		var milliseconds = fmod(Gamestats.level_time, 1) * 100
		var time_string = "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
		$TimeAlive.text = "Time Survived: " + time_string

func _get_main() -> Main:
	if !(get_tree().current_scene is Main):
		print("ERROR: Main scene not found")
	return get_tree().current_scene

func _ready() -> void:
	visible = false

func _on_quit_pressed() -> void:
	get_tree().paused = false
	_get_main()._load_scene(Main.Scenes.MENU)

func _on_respawn_pressed() -> void:
	get_tree().paused = false
	Globals.Main._load_scene(Globals.current_level, Globals.current_leveldata)

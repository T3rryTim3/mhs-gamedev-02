extends Control

var menu
@onready var start = $VBoxContainer2/Start
@onready var creds = $PanelContainer
@onready var strike_sprite:AnimatedSprite2D = $Sprite2D

var strike_cooldown:float = 5

func _process(delta:float):
	strike_cooldown -= delta
	if strike_cooldown <= 0:
		strike_cooldown = randf_range(4,8)
		strike_sprite.global_position.y = 96 * strike_sprite.scale.y * 0.5
		strike_sprite.global_position.x = randi_range(0,get_viewport_rect().size.x)
		strike_sprite.show()
		$Strike.play()
		strike_sprite.play("strike")

func _ready() -> void:
	visible = true
	menu = Globals.main
	menu.visible = false
	creds.visible = false

	strike_sprite.animation_finished.connect(strike_sprite.hide)

func _on_start_pressed() -> void:
	Globals.main.music_man.target_song = "res://Audio/Music/Mystic Garden.wav"
	Globals.main._load_scene(Main.Scenes.LEVEL_SELECT)

func _on_button_pressed() -> void:
	get_tree().quit()

func _on_button_2_pressed() -> void:
	Globals.main.show_settings()

func _on_credits_pressed() -> void:
	creds.visible = true

func _on_samael_pressed() -> void:
	Globals.main.show_achievements()

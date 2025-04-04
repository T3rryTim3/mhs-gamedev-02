extends MarginContainer

@onready var exit_button = $ExitButton
@onready var keybinds = $TabContainer/Game/Keybinds
@onready var misc = $TabContainer/Game/control

func close_menu():
	visible = false

func _ready():
	exit_button.pressed.connect(close_menu)
	keybinds.visible = false
	misc.visible = false



func _on_master_value_changed(value: float) -> void:
	print("Changed")
	AudioServer.set_bus_volume_db(0, linear_to_db($TabContainer/Sound/MarginContainer/VBoxContainer/Master.value))

func _on_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, linear_to_db($TabContainer/Sound/MarginContainer/VBoxContainer/Music.value))
	print(AudioServer.get_bus_volume_db(0))

func _on_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, linear_to_db($TabContainer/Sound/MarginContainer/VBoxContainer/SFX.value))


func _on_keybinds_button_pressed() -> void:
	keybinds.visible = true
	misc.visible = false

func _on_gamemode_button_pressed() -> void:
	misc.visible = true
	keybinds.visible = false
	

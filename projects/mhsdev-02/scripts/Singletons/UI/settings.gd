extends MarginContainer

@onready var exit_button = $ExitButton

func close_menu():
	visible = false

func _ready():
	exit_button.pressed.connect(close_menu)
	_on_master_value_changed()
	_on_sfx_value_changed()
	_on_music_value_changed()

func _on_master_value_changed(_value: float = 1) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db($TabContainer/Sound/MarginContainer/VBoxContainer/Master.value/1000))

func _on_music_value_changed(_value: float = 1) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db($TabContainer/Sound/MarginContainer/VBoxContainer/Music.value/1000))

func _on_sfx_value_changed(_value: float = 1) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db($TabContainer/Sound/MarginContainer/VBoxContainer/SFX.value/1000))


func _on_keybinds_button_pressed() -> void:
	Globals.main.show_keybind_settings()

func _on_gamemode_button_pressed() -> void:
	Globals.main.show_game_settings()

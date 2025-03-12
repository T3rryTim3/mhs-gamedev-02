extends MarginContainer

@onready var exit_button = $ExitButton

func close_menu():
	visible = false

func _ready():
	exit_button.pressed.connect(close_menu)

func _on_master_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db($TabContainer/SoundMenu/MarginContainer/VBoxContainer/Master.value))

func _on_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db($TabContainer/SoundMenu/MarginContainer/VBoxContainer/Music.value))

func _on_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db($TabContainer/SoundMenu/MarginContainer/VBoxContainer/SFX.value))

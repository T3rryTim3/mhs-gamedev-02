extends AspectRatioContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$PanelContainer/SoundMenu/ScrollContainer/VBoxContainer/maestro.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	$PanelContainer/SoundMenu/ScrollContainer/VBoxContainer/musica.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	$PanelContainer/SoundMenu/ScrollContainer/VBoxContainer/sfx.value = db_to_linear(AudioServer.get_bus_volume_db(2))


func _on_sfx_mouse_exited() -> void:
	release_focus()

func _on_musica_mouse_exited() -> void:
	release_focus()

func _on_maestro_mouse_exited() -> void:
	release_focus()

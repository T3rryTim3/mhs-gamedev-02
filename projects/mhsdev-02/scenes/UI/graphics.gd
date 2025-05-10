extends MarginContainer

func _ready():
	pass

func _on_brightness_value_changed(value: float) -> void:
	GameSettings.brightness = value

func _on_bpo_value_changed(value: float) -> void:
	GameSettings.blueprintopac = value

func _on_hbv_toggled(toggled_on: bool) -> void:
	GameSettings.vignette = toggled_on



func _on_glow_toggled(toggled_on: bool) -> void:
	GameSettings.glow = toggled_on

func _on_bloom_toggled(toggled_on: bool) -> void:
	GameSettings.bloom = toggled_on

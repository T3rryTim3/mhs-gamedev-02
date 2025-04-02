extends MarginContainer

@onready var bloom = $VBoxContainer/MarginContainer/VBoxContainer/Glow/Bloom
@onready var glow = $VBoxContainer/MarginContainer/VBoxContainer/Glow
@onready var hbv = $VBoxContainer/VBoxContainer3/HBV
@onready var brightness = $VBoxContainer/VBoxContainer2/Brightness
@onready var bpo = $VBoxContainer/VBoxContainer2/BlueprintOpacity

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

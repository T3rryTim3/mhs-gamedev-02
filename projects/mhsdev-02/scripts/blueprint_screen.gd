extends PanelContainer

@onready var bprint_menu = $MarginContainer/HBoxContainer/Panel
@onready var intern_menu = $MarginContainer/HBoxContainer/Panel/MarginContainer
@onready var bluprints = $MarginContainer/HBoxContainer/Panel/MarginContainer/GridContainer

func _ready():
	bprint_menu.visible = false

func _on_button_pressed() -> void:
	bprint_menu.visible = not bprint_menu.visible

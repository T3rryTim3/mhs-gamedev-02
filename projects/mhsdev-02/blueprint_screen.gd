extends PanelContainer

@onready var bprint_menu = $MarginContainer/HBoxContainer/Panel
@onready var intern_menu = $MarginContainer/HBoxContainer/Panel/MarginContainer
@onready var bluprints = $MarginContainer/HBoxContainer/Panel/MarginContainer/GridContainer

func _ready():
	bprint_menu.visible = false

func _set_menu(menu):
	var wasClosed = menu.visible == false
	
	_close_all_menus()
	
	bprint_menu.visible = wasClosed
	menu.visible = wasClosed

func _close_all_menus():
	for menu in intern_menu.get_children():
		menu.visible = false



func _on_button_pressed() -> void:
	_set_menu(bluprints)

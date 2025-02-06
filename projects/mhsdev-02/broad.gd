extends PanelContainer





func _on_mouse_entered() -> void:
	Popuppanel.ItemPopup(null,null)



func _on_mouse_exited() -> void:
	Popuppanel.HideItemPopup(null,null)

extends Control


func ItemPopup(slot : Rect2i,item):
	
	var mouse_pos = get_viewport().get_mouse_position()
	var correction
	
	%ItemPopup.popup()

func HideItemPopup(slot,item):
	%ItemPopup.hide()

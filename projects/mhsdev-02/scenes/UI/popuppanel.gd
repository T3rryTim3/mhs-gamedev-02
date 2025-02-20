extends Control

var cost_item = preload("res://scenes/UI/cost_item.tscn")

func load_item_from_station(station:StationData.Stations): ## Loads item data into the display
	
	# Clear current display items
	for x in %ItemPopup/VBoxContainer.get_children():
		x.queue_free()
	
	var cost = StationData.get_station_cost(station)
	for k in cost:
		# Add display
		var item = cost_item.instantiate()
		%ItemPopup/VBoxContainer.add_child(item)
		
		item.label.text = "0/" + str(cost[k])
		item.texture_rect.texture = load(ItemData.get_item_data(k)["img_path"])
		item.id = k
		item.z_index = 1
		item.mouse_filter = MouseFilter.MOUSE_FILTER_PASS	

func ItemPopup(slot : Rect2i,item):
	
	var mouse_pos = get_viewport().get_mouse_position()
	var correction
	var padding = 4
	
	if mouse_pos.x <= get_viewport_rect().size.x/2:
		correction = Vector2i(slot.size.x + padding, 0)
	
	else:
		correction = -Vector2i(%ItemPopup.size.x + padding, 0)
	%ItemPopup.popup(Rect2i(slot.position + correction, %ItemPopup.size))
	load_item_from_station(item.target_station)
	%ItemPopup.show()

func HideItemPopup():
	%ItemPopup.hide()
	print("hidden")

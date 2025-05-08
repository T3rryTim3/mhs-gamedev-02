extends Control


func _load_achievements() -> void:
	for child in $Achibement.get_children():
		child.queue_free()
	
	
	var data = Achievements.get_data()
	
	if data.size() == 0:
		print("Achievements data is empty.")
		return
	
	
	

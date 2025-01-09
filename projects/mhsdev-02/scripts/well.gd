extends Station

## Preload dropped resource
var drop = preload("res://scenes/Base/item.tscn")

func produce():
	super()
	var new_drop:Item = drop.instantiate()
	new_drop.id = 2
	new_drop.position = $DropPos.position
	new_drop.apply_force(Vector3(randi_range(50,200),randi_range(-60,60),0))
	
	add_child(new_drop)

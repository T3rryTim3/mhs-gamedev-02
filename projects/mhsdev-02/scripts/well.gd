extends Station

## Preload dropped resource
var drop = preload("res://scenes/Base/item.tscn")

## Changes the item "fling" value when dropped
@export var fling_coef:float=1

func produce():
	super()
	var new_drop:Item = drop.instantiate()
	new_drop.id = new_drop.ItemTypes.WATER
	new_drop.position = $DropPos.position
	new_drop.apply_force(Vector3(randi_range(50,200),randi_range(-60,60),0) * fling_coef)
	
	add_child(new_drop)

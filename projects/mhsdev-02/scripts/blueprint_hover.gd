extends Area2D
class_name BlueprintHover

@onready var sprite = $Sprite2D

var station:StationData.Stations : set = _update_sprite
var valid = false

func _update_sprite(new:StationData.Stations):
	if station != new:
		$Sprite2D.texture = load(StationData.get_station_texture(new))

	var size = $Sprite2D.texture.get_size()
	$CollisionShape2D.shape.size = size / 1.2
	$ColorRect.size =  size
	$ColorRect.position = size * -1/2
	station = new

func update() -> void:
	var collide = false
	for x in get_overlapping_bodies():
		collide = true
	if collide: # Set the shader color based on position validity
		sprite.material.set_shader_parameter("green", 0)
		sprite.material.set_shader_parameter("red", 1)
		valid = false
	else:
		sprite.material.set_shader_parameter("green", 1)
		sprite.material.set_shader_parameter("red", 0)
		valid = true

func place(parent:Node) -> void:
	var new_station = load("res://scenes/Base/blueprint.tscn").instantiate()
	new_station.target_station = station
	parent.add_child(new_station)
	new_station.global_position = global_position

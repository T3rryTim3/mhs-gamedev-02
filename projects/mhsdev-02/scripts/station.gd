extends Entity
class_name Station

## Default texture
var DEFAULT_PROGRESS_TEXTURE = load("res://Resources/station_default_progress.tres")

## Default fling for item spawning
var DEFAULT_FLING_VAL:int = 160

## Preload dropped resource
var drop = preload("res://scenes/Base/item.tscn")

## Preload blueprint collider
var blueprint_collider = preload("res://scenes/Structure/blueprint_collider.tscn")

enum LayerBehaviour
{
	ADAPTIVE,
	BELOW,
	ABOVE
}

## Station data
@export var station_data:StationData.Stations

## Progress bar offset relative to healthbar
@export var progress_bar_offset:float = 10

## Behavoir for display in relation to the player
@export var layer_behavior:LayerBehaviour = LayerBehaviour.ADAPTIVE

## Time to fully process
@export var produce_time:float = 5

## (Animation) ending y-scale value when process finished
@export var produce_stretch:float = 0.2

## Progress bar gradient
@export var progress_bar_texture:Texture2D

## Progress bar object
@onready var progress_bar:StatBar

## Timer object
@onready var progress_timer:Timer = Timer.new()

## Force multi to dropped resources
@export var fling_coef:float = 1

## Can be refrenced for station counting in the level (Used for effect stations)
var active:bool = true

## (Animation) Current stretch value
var stretch_val:float = 0

## (Animation) Animation length
var stretch_time:float = 0.15

func create_item(id:ItemData.ItemTypes, item_force:Vector2=Vector2.ZERO):
	var new_drop:Item = drop.instantiate()
	new_drop.id = id
	new_drop.global_position = $DropPos.global_position
	
	item_force = item_force.normalized()
	
	new_drop.apply_force(Vector2(item_force.x * DEFAULT_FLING_VAL, item_force.y * DEFAULT_FLING_VAL) * fling_coef)
	
	get_parent().add_child(new_drop)

func produce_anim(delta): ## Production animation
	stretch_val += delta
	if stretch_val < stretch_time:
		sprite.scale.y = 1 + (sin((stretch_val * PI) / stretch_time)) * produce_stretch
	else:
		sprite.scale.y = 1

func produce(): ## Produce logic; default nothing
	stretch_val = 0

func _init_progress_bar(): ## Reset the progress bar
	
	var sprite_texture = get_sprite_texture()

	# Instantiate health bar
	progress_bar = stat_bar.instantiate()
	progress_bar.texture_width = sprite_texture.get_width() * sprite.scale.x
	progress_bar.texture_height = sprite_texture.get_height() * sprite.scale.y

	progress_bar.thickness = 0.01

	progress_bar.position.y = (-sprite_texture.get_height()/2.0)*sprite.scale.y
	progress_bar.position.y -= progress_bar_offset

	progress_bar.size_scale = health_bar.size_scale * 0.5
	
	progress_bar.texture_progress = progress_bar_texture

	add_child(progress_bar)

func _death():
	# Create blueprint when destroyed
	var new_station = load("res://scenes/Base/blueprint.tscn").instantiate()
	new_station.target_station = station_data
	get_parent().call_deferred("add_child", new_station)
	new_station.global_position = global_position

	# Delete self
	queue_free()

func _process(delta):
	super(delta)
	# Update progress bar
	progress_bar.current = (progress_timer.time_left / progress_timer.wait_time)
	produce_anim(delta)
	
	match layer_behavior:
		0:
			# Check if the player is above the station based on camera pos
			if get_viewport().get_camera_2d().global_position.y + 24 <global_position.y + get_sprite_texture().get_height()/2.0:
				z_index = 5
			else:
				z_index = -1
		1:
			z_index = -1
		2: 
			z_index = 5
	

func _ready():
	
	add_to_group("station")
	
	if not sprite:
		sprite = $Sprite2D
	
	if not progress_bar_texture:
		progress_bar_texture = DEFAULT_PROGRESS_TEXTURE
	
	super()
	_init_progress_bar()
	
	progress_timer.one_shot = false
	progress_timer.wait_time = produce_time
	progress_timer.connect("timeout", produce)

	add_child(progress_timer)

	progress_timer.start()

	var collider = blueprint_collider.instantiate()
	add_child(collider)
	collider.collision_shape.shape.size = get_sprite_texture().get_size()

	# Align station to grid
	global_position = _round_vector(global_position, 24)

	# Add shader for selection
	sprite.material = load("res://Resources/station_select_shader.tres")

	

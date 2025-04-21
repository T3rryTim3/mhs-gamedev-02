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

## Preload remove collider
var remove_collider = preload("res://scenes/Structure/station_remove_collider.tscn")

## Used to prevent dying multiple times at once
var dying = false

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

## Whether or not to display the progress bar
@export var show_progress:bool = true

## Progress bar object
@onready var progress_bar:StatBar

## Timer object
@onready var progress_timer:Timer = Timer.new()

## Can be refrenced for station counting in the level (Used for effect stations)
var active:bool = true

## If the station can currently be removed (If the mouse is hovering over and player is in delete mode)
var can_delete:bool = false

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
	
	if !show_progress:
		progress_bar.visible = false

	add_child(progress_bar)

func _death():
	# Create blueprint when destroyed
	if dying:
		return
	dying = true
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
			pass
			if get_viewport().get_camera_2d().global_position.y + 24 <global_position.y + get_sprite_texture().get_height()/2.0:
				z_index = 5
			else:
				z_index = -1
		1:
			z_index = -1
		2: 
			z_index = 5

	_check_delete()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if can_delete:
			queue_free()

func _ready():
	var level = _get_level()

	# Ensure the level is loaded
	if !level.loaded:
		await _get_level().ready

	add_to_group("station") # Used for processing total station benefits

	# Default values
	if not sprite:
		sprite = $Sprite2D # Can be manually reset using the exported variable
	
	if not progress_bar_texture:
		progress_bar_texture = DEFAULT_PROGRESS_TEXTURE

	# Done after to ensure default values are present
	super()
	_init_progress_bar()
	
	# Accout for level settings
	produce_time *= 1 / level.level_data.station_speed_multi # Take the reciprocal as produce_time is different from speed

	progress_timer.one_shot = false
	progress_timer.wait_time = produce_time
	progress_timer.connect("timeout", produce)

	add_child(progress_timer)

	progress_timer.start()

	# Used for checking if the station is colliding with other stations during placement
	var collider = blueprint_collider.instantiate()
	add_child(collider)
	collider.get_child(0).shape.size = get_sprite_texture().get_size()

	# Align station to grid
	global_position = _round_vector(global_position, 24)

	# Add shader for selection
	sprite.material = load("res://Resources/station_select_shader.tres")

func _check_delete():
	var glob_mouse = get_global_mouse_position()
	var sizex = get_sprite_texture().get_size().x
	var sizey = get_sprite_texture().get_size().y
	
	can_delete = false
	if (glob_mouse.x > global_position.x - sizex/2) and (glob_mouse.x < global_position.x + sizex/2):
		if (glob_mouse.y > global_position.y - sizey/2) and (glob_mouse.y < global_position.y + sizey/2):
			if _get_level().player.delete_mode:
				can_delete = true

	_update_remove_color(can_delete)

func _update_remove_color(on:bool):
	if on:
		sprite.self_modulate = Color(40,1,1)
	else:
		sprite.self_modulate = Color(1,1 - damage_mod_coef,1 - damage_mod_coef)

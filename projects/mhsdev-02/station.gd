extends Entity
class_name Station

## Progress bar offset relative to healthbar
@export var progress_bar_offset:float = 10

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

## (Animation) Current stretch value
var stretch_val:float = 0

## (Animation) Animation length
var stretch_time:float = 0.15

func produce_anim(delta): ## Production animation
	stretch_val += delta
	if stretch_val < stretch_time:
		sprite.scale.y = 1 + (sin((stretch_val * PI) / stretch_time)) * produce_stretch
	else:
		sprite.scale.y = 1

func produce(): ## Produce logic; default nothing
	stretch_val = 0

func _init_progress_bar(): ## Reset the progress bar
	
	var sprite_texture = _get_sprite_texture()

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

func _process(delta):
	super(delta)
	# Update progress bar
	progress_bar.current = (progress_timer.time_left / progress_timer.wait_time)
	produce_anim(delta)
	

func _ready():
	super()
	_init_progress_bar()
	
	progress_timer.one_shot = false
	progress_timer.wait_time = produce_time
	progress_timer.connect("timeout", produce)
	
	add_child(progress_timer)
	
	progress_timer.start()

	

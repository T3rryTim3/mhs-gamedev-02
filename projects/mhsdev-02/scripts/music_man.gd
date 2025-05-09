extends Node
class_name MusicMan

@onready var stream:AudioStreamPlayer = $Music

var current_song:String
var target_song:String

var fade_progress:float = 1
var fade_speed:float = 2

var lp_toggle:bool = false # Toggles the low-pass filter
var lp_time:float = 0.15 # Time in seconds for the filter to lerp

#func set_target_song(new:String):
	#if not new:
		#lp_toggle = false
	#target_song = new

func _process(delta: float) -> void:

	# Handle song fading
	stream.volume_linear = fade_progress
	if target_song != current_song:
		fade_progress = max(0, fade_progress - delta * fade_speed)
		if fade_progress <= 0:
			if target_song:
				stream.stream = load(target_song)
				stream.playing = true
				current_song = target_song
			else:
				lp_toggle = false
	elif fade_progress < 1:
		fade_progress = min(1, fade_progress + fade_speed * delta)

	# Low-pass filter
	var lp_effect : AudioEffectLowPassFilter = AudioServer.get_bus_effect(1,0)
	if lp_toggle:
		AudioServer.set_bus_effect_enabled(1,0,true)
		lp_effect.cutoff_hz = lerpf(lp_effect.cutoff_hz, 716, delta * (1/lp_time))
	else:
		lp_effect.cutoff_hz = lerpf(lp_effect.cutoff_hz, 20500, delta * (1/lp_time))
		if lp_effect.cutoff_hz >= 20000:
			AudioServer.set_bus_effect_enabled(1,0,false)

extends Node

enum Events {
	TORNADO
}

## The log base used for difficulty scaling.
var scale_base = 2

func _log_base(value:float, base:int): 
	return log(value) / log(base)

func scale_val(value:float): ## Scales a value logarithmically based on scale_base.
	return _log_base(value + 1, scale_base) # Add 1 to offset equation

class EventData:
	var event_name : String
	var scene_path : String
	var duration : int
	var strength : float

	func _init(nm:String, pth:String, dur:int, stren:float):
		self.event_name = nm
		self.scene_path = pth
		self.duration = dur
		self.strength = stren

func get_event_data(event:Events, strength:float = 1) -> EventData:
	strength = max(0, strength)
	match event:
		0: # Tornado
			return EventData.new(
				"tornado",
				"res://scenes/Events/tornado.tscn",
				10 * scale_val(strength),
				strength
			)
	return null

func spawn_event(event:Events, parent:Node, strength:float = 1):
	print("Event spawned.")
	var data:EventData = get_event_data(event, strength)
	
	if not data:
		print("EVENT NOT FOUND")
		return
	
	var event_scn:Event = load(data.scene_path).instantiate()
	
	event_scn.data = data
	
	parent.add_child(event_scn)
	event_scn.spawn()

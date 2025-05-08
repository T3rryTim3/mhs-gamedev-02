extends Node

# TODO Call kill() on expired events

signal event_spawned

enum Events {
	TORNADO,
	VOLCANO,
	STORM,
	BLIZZARD
}

var spawned_events:Array = []

## The log base used for difficulty scaling.
var scale_base = 2

func _log_base(value:float, base:int): 
	return log(value) / log(base)

func is_event(event:Events) -> bool: ## If the given event is present
	for k in spawned_events:
		if k.event_enum == event:
			return true
	return false

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
		Events.TORNADO:
			return EventData.new(
				"tornado",
				"res://scenes/Events/tornado.tscn",
				15,
				strength
			)
		Events.VOLCANO:
			return EventData.new(
				"volcano",
				"res://scenes/Events/volcano.tscn",
				20,
				strength
			)
		Events.STORM:
			return EventData.new(
				"storm",
				"res://scenes/Events/storm.tscn",
				30,
				strength
			)
		Events.BLIZZARD:
			return EventData.new(
				"blizzard",
				"res://scenes/Events/blizzard.tscn",
				30,
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
	event_scn.event_enum = event

	parent.add_child(event_scn)
	event_scn.spawn()

	spawned_events.append(event_scn)
	event_scn.tree_exited.connect(spawned_events.erase.bind(event_scn))

	Gamestats.events_spawned += 1

	event_spawned.emit()

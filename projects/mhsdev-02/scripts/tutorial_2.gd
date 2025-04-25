extends Level
class_name Tutorial

func _ready():
	super()
	tutorial = true
	level_data.hunger_multi = 0
	level_data.thirst_multi = 0
	level_data.event_cooldown = 1000000000
	level_data.item_spawn_cooldown = 1000000000
	load_machine_step()
	current_event_cooldown = -100000

func load_bread_step(): ## Loads everything for the bread cooking tutorial step 
	var station_scene = load(StationData.get_station_scene(StationData.Stations.OVEN))
	var station = station_scene.instantiate()
	station.global_position = $OvenPos.global_position
	stations.add_child(station)

func load_machine_step(): ## Loads everything for the bread 
	var machine:Machine = $"Map/The Machine"
	machine.global_position = $MachinePos.global_position

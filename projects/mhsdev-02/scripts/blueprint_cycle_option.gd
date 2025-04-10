extends TextureRect

var station:StationData.Stations : set = _set_state

var station_index:int = 0

func _set_state(new):
	texture = load(StationData.get_station_texture(new))
	station = new

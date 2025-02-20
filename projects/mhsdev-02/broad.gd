extends PanelContainer

@export var target_station:StationData.Stations

@onready var texture = $TextureRect

func _on_mouse_entered() -> void:
	Popuppanel.ItemPopup(Rect2i( Vector2i(global_position) , Vector2i(size)),self)

	print("show" + str(randf()))

func _on_mouse_exited() -> void:
	Popuppanel.HideItemPopup()
	print("Hidden")

func _ready() -> void:
	var image = load(StationData.get_station_texture(target_station))
	texture.texture = image
	

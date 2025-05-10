extends MarginContainer

@onready var vbox = $VBoxContainer

var player:Player

var actions = {
	"blueprint": ["Build", false],
	"place": ["Place", false],
	"pickup": ["Pick up", false],
	"use": ["Use item", false],
	"attack": ["Attack", false],
	"drop": ["Drop item", false]
}

func _get_key(action:String) -> String: ## Get the string version of an action's event
	return InputMap.action_get_events(action)[0].as_text().rstrip(" (Physical)")

func display_actions() -> void:

	var present = []
	for child in vbox.get_children():

		 #Don't delete if still relevant
		#if actions[child.get_meta("action")][1]:
			#present.append(child.get_meta("action"))
			#continue

		child.queue_free()

	for k in actions:

		# Only if enabled
		if !actions[k][1]:
			continue

		# Prevent the same item twice
		if k in present:
			continue

		var label = Label.new()
		label.text = actions[k][0] + ": " + _get_key(k)
		label.set_meta("action", k)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		vbox.add_child(label)

func _is_active(action) -> bool:
	match action:
		"blueprint":
			return player.current_blueprint == null
		"place":
			return player.current_blueprint != null
		"pickup":
			return len(player.collector.current_resources) < player.collector.stack_limit and len(player.hovered_items) > 0
		"use_item":
			return len(player.collector.current_resources) > 0
		"attack":
			return len(player.collector.current_resources) == 0
		"drop":
			return len(player.collector.current_resources) > 0

	return false

func _process(_delta: float) -> void:
	var old = actions.hash()
	#print(actions)
	for k in actions:
		actions[k][1] = _is_active(k)
	if old != actions.hash():
		display_actions()

func _ready() -> void:
	player = Globals.level.player

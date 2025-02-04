extends TextureRect

# Declare a reference to the ColorRect that will act as the hover box
@onready var hover_box = $Panel  # Assumes the ColorRect is a child of TextureRect

func _ready():
	# Initially hide the hover box
	hover_box.visible = false

# Signal for when the mouse enters the TextureRect
func _on_TextureRect_mouse_entered():
	hover_box.visible = true  # Show the hover box when mouse enters

# Signal for when the mouse exits the TextureRect
func _on_TextureRect_mouse_exited():
	hover_box.visible = false  # Hide the hover box when mouse exits

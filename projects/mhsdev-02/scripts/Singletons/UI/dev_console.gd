extends CanvasLayer

var expression = Expression.new()

@onready var line_edit = $MarginContainer/VBoxContainer/LineEdit
@onready var text_label = $MarginContainer/VBoxContainer/RichTextLabel

func test():
	return "Success!"

func _ready():
	line_edit.text_submitted.connect(self._on_text_submitted)

func _on_text_submitted(command):
	var error = expression.parse(command)
	if error != OK:
		print(expression.get_error_text())
		return
	var result = expression.execute([], self)
	if not expression.has_execute_failed():
		text_label.text = str(result)
		line_edit.text = ""

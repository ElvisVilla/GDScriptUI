extends View
class_name OtherView


@onready var viewport_size: Vector2i = get_viewport().get_window().get_size()
var description: String = "Here is your text":
	set(value):
		description = value
		observe("description", value)

var number: int = 0:
	set(value):
		number = value
		observe("number", value)

func _ready():
	body = [
		VBox([
			Label("Project Design")
				.fontSize(48),

			Label("Description:"),

			TextEdit(description, "Write Here")
				.wordWrap(true)
				.fontSize(20)
				#Size flags needs to go at the end of the chain
				.size_flags(View.SizeFlags.EXPAND_FILL, View.SizeFlags.EXPAND_FILL),

			Button("Submit")
				.onPressed(func(): number += 1)
				.padding(), # Padding makes a margin container
				# .size_flags(View.SizeFlags.FILL, View.SizeFlags.FILL),
			Spacer(),

			HBox([
				Button("Submit")
				.onPressed(func(): number += 1)
				.padding(),

				Spacer(),
			]),
		])
		.size_flags(View.SizeFlags.EXPAND_FILL, View.SizeFlags.EXPAND_FILL),
	]

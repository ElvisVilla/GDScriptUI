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
				.fontSize(24)
				.padding(10),
			
			HBox([
				Label("Description 1"),
				Label("Description 2"),
				Label("Description 3"),
			])
			.spacing(20),

			VBox([

			]),
		])
		.fontSize(38),
	]

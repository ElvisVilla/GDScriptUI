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

			HBox([
				HBox([

					Button("UpdateUI")
						.onPressed(func(): number += 1)
						.expandFillVertical(),

					Button("YAA")
						.padding(),

					Button("YOO")
						.padding(10),

				], "Buttons Horizontal")
				.fontSize(18)
				.background(Color.BLACK.lightened(0.2), 10),

				HBox([
					Label("Lable 1"),

					Label("Label 2"),
				]),

			]),
			
			Label("Project Design")
				.fontSize(24)
				.padding(2),
			
			HBox([
				Label("Description 1").padding(1),
				Label("Description 2").padding(1),
				Label("Description 3").padding(1),
			], "Labels container")
			.spacing(20),

		], "VBox outermost container in Body")
			.fontSize(38)
			.background(Color.BLACK.lightened(0.3), 10),
	]

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
						.onPressed(func(): number += 1),

					Button("YAA")
						# .frame(Infinity, Infinity)
						.tooltip("This is a tooltip"),

					Button("YOO"),

					VBox([
						Label("Hello")
							.align(TextAlignment.CENTER, TextAlignment.TOP),
					]),

				], "Buttons Horizontal")
				.fontSize(18)
				.background(Color.BLACK.lightened(0.2), 10)
				.frame(Infinity, Infinity),

				HBox([
					Label("First label that has some text to make something popup")
						.autowrap(TextServer.AUTOWRAP_ARBITRARY),

					Label("Long description to see how this works")
					.autowrap(TextServer.AUTOWRAP_ARBITRARY),
				])
				.frame(Infinity, Infinity),

			]),
			
			Label("Project Design")
				.background(Color.BLACK.lightened(0.4), 10)
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

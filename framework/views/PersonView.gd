extends View
class_name PersonView

var names: Array = ["Lucy", "Albert", "Niklas", "John", "Mariela"]

#Observed property
var person_name: String = "Lucy":
	set(value):
		person_name = value
		observe("person_name", person_name)

enum Alignment {
	LEFT = 0,
	Center = 1,
	Right = 2,
}

var alignment_value: Alignment = Alignment.Center:
	set(value):
		alignment_value = value
		observe("alignment_value", alignment_value)

# func _init(named: String) -> void:
# 	person_name = named

func _ready() -> void:
	body = [

		VBox([

			Label("Content View")
				.fontSize(26)
				.align(alignment_value)
				.size_flags(SizeFlags.EXPAND_FILL)
				.padding(),

			HBox([

				Label(person_name)
					.align(1),

				Image("res://icon.svg")
					.expand_mode(ExpandMode.IGNORE_SIZE)
					.stretch_mode(StretchMode.KEEP_ASPECT_CENTERED)
					.frame(50, 50)
					.visible(person_name == "Lucy"),

				Button("Random Name")
					.onPressed(func(): person_name = names.pick_random())
					.padding(),

			])
			.padding()
			.background(Color.BLACK.lightened(0.3), 10)
			.padding(),

			TextEdit(person_name if person_name != ""
				else "Enter your name", "Enter your name")
				.frame(50, 50)
				.padding()
				.background(Color.BLACK.lightened(0.3), 10)
				.padding(),
		])
	]

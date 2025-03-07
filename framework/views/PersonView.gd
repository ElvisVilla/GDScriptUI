extends View
class_name PersonView

enum Alignment {
	LEFT = 0,
	Center = 1,
	Right = 2,
}

var names: Array = ["Lucy", "Albert", "Niklas", "John", "Mariela"]

var show_content: bool = true:
	set(value):
		show_content = value
		observe("show_content", show_content)

#Observed property
var person_name: String = "Lucy":
	set(value):
		person_name = value
		observe("person_name", person_name)

var alignment_value: Alignment = Alignment.Center:
	set(value):
		alignment_value = value
		observe("alignment_value", alignment_value)

func configure(person_name: String = "Lucy"):
	self.person_name = person_name
	
func _ready() -> void:
	body = [

		VBox([

			ForEach(range(0, 6),
				func(i): return ViewTest().padding()
			),

			Button("Hide content")
				.onPressed(func(): show_content = !show_content),

			AppUI("Hello", "Lucy")
				.visible(show_content),

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

extends View
class_name PersonView

enum Alignment {
	LEFT = 0,
	Center = 1,
	Right = 2,
}

var another_names = ["Hola que tal", "Soy un texto\n largo", "Tengo algunas palabras",
 "Martha camina por la calle", "John anda por la calle"]

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
	
func _ready():
	body = [

		VBox([

			Label(another_names[0] + " " + another_names[1] + " " + another_names[2] + " " + another_names[3] + " " + another_names[4]),
			Label(another_names[1]),
			Label(another_names[2]),
			Label(another_names[3]),
			Label(another_names[4]),
			Label("Content View")
				.fontSize(26)
				.size_flags(SizeFlags.EXPAND)
				.padding(),

			HBox([

				Label(person_name),

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
		.padding()
		.background(Color.BLACK.lightened(0.3), 10)
		.padding(),
	]

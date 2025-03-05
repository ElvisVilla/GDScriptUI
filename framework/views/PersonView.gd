extends View
class_name PersonView

var names: Array = ["Lucy", "Albert", "Niklas", "John", "Mariela"]

#Observed property
var person_name: String = "Lucy":
	set(value):
		person_name = value
		observe("person_name", person_name)

# func _init(named: String) -> void:
# 	person_name = named

func _ready() -> void:
	body = [

		VBox([

			Label("Content View").fontSize(26).padding(),
			HBox([
				Label(person_name)
					.frame(100, 50)
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
			.alignment(BoxContainerAlignment.END)
			.padding()
			.background(Color.BLACK.lightened(0.3), 10)
			.padding(),

			TextEdit(person_name if person_name != ""
			 	else "Enter your name", "Enter your name")
				.frame(500, 50)
				.padding()
				.background(Color.BLACK.lightened(0.3), 10)
				.padding(),

		])
		.frame(500, 500)
		.alignment(BoxContainerAlignment.BEGIN)
	]

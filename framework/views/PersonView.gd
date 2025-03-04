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

		VBox("", [
			HBox("Person container", [
				
				Label(person_name)
					.frame(100, 50, true, false)
					.align(1)
					.fontSize(20),

				Image("res://icon.svg")
					.expand_mode(ExpandMode.IGNORE_SIZE)
					.frame(50, 50)
					.visible(person_name == "Lucy"),

				Button("Random Name")
					.onPressed(func(): person_name = names.pick_random())
					.padding()
					.onHover(func(): print("hovering on random name button"))

			])
			.spacing(4)
			.padding(10)
			.background(Color.BLACK, 10)
			.padding(10),

			TextEdit(person_name if person_name != "" else "Enter your name", "Enter your name")
				.frame(500, 50)
				.padding(10)
				.textColor(Color.DARK_CYAN)
				.editable(false)
				.background(Color.PINK, 10)
				.padding(10),
		])
		.padding(10)
		.background(Color.DARK_CYAN, 10)
		.spacing(100)
	]

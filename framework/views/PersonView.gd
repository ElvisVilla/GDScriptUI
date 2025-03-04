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
		HBox("Person container", [
			
			Label(person_name)
				.frame(100, 50).align(1).fontSize(20), # ',' defines the end of the component

			Image("res://icon.svg")
				.expand_mode(ExpandMode.IGNORE_SIZE)
				.frame(50, 50) # We can define our own size
				.visible(person_name == "Lucy"),

			Button("Random Name")
				.onPressed(func(): person_name = names.pick_random())
				.padding()
				# .corner_radius(10)
		])
		.spacing(5).padding(16)
	]

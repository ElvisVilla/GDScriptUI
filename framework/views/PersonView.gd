extends View
class_name PersonView

var names: Array = ["Katja", "Elvis", "Juan", "Paola", "Lina", "Mariela", "Ruth", "Thom", "Urshy"]

var person_name: String:
	set(value):
		person_name = value
		observe("person_name", person_name)

func _init(elvis_argument: String) -> void:
	person_name = elvis_argument

func _ready() -> void:
	body = [
		HBox("Person container", [
			Label(person_name),
			Image("res://icon.svg")
				.expand_mode(ExpandMode.IGNORE_SIZE)
				.frame(50, 50),

			Button("Random Name").onPressed(func(): person_name = names.pick_random())
		])
	]


func _just_want_to_tell_you_that_i_love_you(from_elvis: String, to_Lina: String) -> void:
	pass

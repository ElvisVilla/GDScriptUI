extends View
class_name ViewTest

var hello_world: String = "Hello World"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body = [

		Label(hello_world)
		.fontSize(26)
	]

extends View
class_name ViewTest

var hello_world: Binding

# func configure(message: Binding):
# 	hello_world = message

# Called when the node enters the scene tree for the first time.
func configure(message) -> void:
	hello_world = message
	body = [
		HBox([
			Label(hello_world)
			.fontSize(26),
		], "Builder or Hboxcontainer"),
	]

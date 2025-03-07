# meta-name: View Extension
# meta-description: Extension for View
# meta-default: true
# meta-space-indent: 4

extends _BASE_
class_name _CLASS_


func _ready():
	#Body is where all the UI elements are defined
	body = [
		VBox([
			Label("Hello World"),
			Button("Click me")
		])
	]

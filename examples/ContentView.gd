extends View
class_name ContentView


func _ready():
	#Body is where all the UI elements are defined
	body = [
		VBox([
			Label("Hello World"),
			Button("Click me"),

			SimpleView()
		])
	]

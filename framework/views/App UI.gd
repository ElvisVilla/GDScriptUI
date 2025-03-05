extends View
class_name AppUI

@export var elements: Array[String] = ["grass", "Shovel", "Sword", "Plant"]:
	set(value):
		elements = value
		observe("elements", value)

const view_name = "App UI"
var nestedContent: View

# Use property setters for observed properties
var showContent = false:
	set(value):
		showContent = value
		observe("showContent", value)
var showContent2 = false:
	set(value):
		showContent2 = value
		observe("showContent2", value)
var to_concert_with = "Mi Amor":
	set(value):
		to_concert_with = value
		observe("to_concert_with", value)
var count = 0:
	set(value):
		count = value
		observe("count", value)
var person_name = "John Doe":
	set(value):
		person_name = value
		observe("person_name", value)

func _ready():
	body = [
		VBox("App UI", [
			Label(view_name).fontSize(30),

			VBox("Labels", [

				VBox("Toggles", [

					Label("Toggles")
						.fontSize(20),

					Button("Toggle Show Content 1")
						.fontSize(15)
						.onPressed(func(): showContent = !showContent),

					Button("Toggle Show Content 2")
						.fontSize(15)
						.onPressed(func(): showContent2 = !showContent2),

					Button("Make Nested Content")
						.fontSize(15)

				]),
			]),

			Button("Counter")
				.fontSize(15)
				.onPressed(func(): count += 1)
				.visible(showContent),
			
			Label("This content is visible: " + str(showContent2)),

			ForEach(elements,
				func(element):
					return VBox("Element", [
						Label(element if element != null else "No value").fontSize(12),
						Button(element if element != null else "No value").fontSize(12),
						Button("Hello").fontSize(12),

						Image("res://icon.svg")
							.frame(50, 50, true)
							.visible(count < 5),

						Image("res://icon.svg")
							.frame(50, 50, true)
							.visible(count >= 7),
					]),
			),

			ForEach(elements,
			func(element):
				return Label(element if element != null
				else "No value")),

			ForEach(elements,
			func(item):
			return Button(item) \
				.onPressed(func(): print("pressing " + item))),

		])
		.padding(16)
	]


func PersonView(named: String):
	return build_nested_view("PersonView",
	 load("res://framework/views/PersonView.gd").new(named),
	  self)

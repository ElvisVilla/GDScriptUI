extends View
class_name SimpleView

var items = ["Sword", "Shield", "Potion"]

func _ready():
	body = [
		VBox([
			Label("Inventory")
				.fontSize(78),
			
			ForEach(items, func(item):
				return Label(item).align(TextAlignment.CENTER))
			.vertical() # makes the labels stack vertically
		])
		.spacing(10)
		.background(Color.BLACK.lightened(0.2), 10)
	]
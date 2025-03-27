extends View
class_name OtherView

#TODO: Reload script when the script changes, to reflect new code lines when the UI is running
var data = [
	Item.new("Sword", "This is the ancient sword that defeats the darkness, use it peace maker!"),
	Item.new("Shield", "The protector of the realm, made of a theet of a dragon and forge with diamond on the edges"),
	Item.new("Boots", "Boots that lets you move faster"),
	Item.new("The Protector", "Chest that was made to protect the realm"),
	Item.new("Balancer", "Orb that balance the stats of the porter"),
]

var vertical: bool = false:
	set(value):
		vertical = value
		observe("vertical", value)

var number: int = 0:
	set(value):
		number = value
		observe("number", value)

func _ready():
	body = [
		HBox([
			Button("Hello World")
				.fontSize(44)
				.frame(Infinity, Infinity)
				.padding(10).
				visible(false),

			VBox([

				HBox([
					HBox([
						Button("UpdateUI")
							.onPressed(func(): number += 1),

						Button("YAA")
							.tooltip("This is a YAAA Button"),

						Button("YOO")
							.background(Color.RED, 360)
							.tooltip("This is a YOO Button"),

					])
					.fontSize(18)
					.padding()
					.background(Color.BLACK.lightened(0.2), 10),

					HBox([
						Label("First label that has some text to make something popup"),

						Label("Long description to see how this works")
							.frame(Infinity),
					], "Labels HBOX"),
				]),
				
				HBox([

					Label("Description 1 some other text to test the autowrap")
						.frame(Infinity),

					Label("Another Text")
						.frame(Infinity),

					Label("Description 3")
						.frame(Infinity),
					
				]),

				Button("Horizontal" if vertical else "Vertical")
					.onPressed(func(): vertical = !vertical),

				#ForEach returns a ContainerBuilder with all the card_items inside
				ForEach(data, func(item): return card_item(item))
					.changeToVertical(true if vertical else false)
					.frame(800, 600),

			])
				.fontSize(18)
				.background(Color.BLACK.lightened(0.3), 10),
		])
		.background(Color.BLACK.lightened(0.1), 10)
		.padding(10),
	]


func item_label(text) -> LabelBuilder:
	var label = Label(text).align(TextAlignment.CENTER)
	return label

func title_label(text) -> LabelBuilder:
	var label = Label(text).fontSize(50).align(TextAlignment.CENTER)
	return label

func card_item(item: Item) -> ContainerBuilder:
	return VBox([

		title_label(item.itemName)
		.padding(),

		item_label(item.itemDescription)
		.padding(),

	]) \
	.spacing(10) \
	.alignment(BoxContainerAlignment.BEGIN) \
	.background(Color.BLACK.lightened(0.4), 10)

extends View
class_name OtherView

var names = ObserveArray.new(["Carmen", "Mariela", "Elier", ])
var empty: Array[String]
var should_vertical: Binding = Binding.new(false)
var show_item = Binding.new(true)
var desc3: Binding = bind("Here is some medium-size text")
var paddin_amount := bind(20)

func configure() -> void:
	body = [
		HBox([

			HBox([
				Button("Update")
				.onPressed(func():
					desc3.value = ["Binding", "Signals", "Groups"].pick_random()
					show_item.value = !show_item.value
					),

				Button("Add Item")
					.onPressed(func(): names.append("Elvis")),

				Button("Remove Item")
					.onPressed(func(): names.remove_last()),

				ViewTest(desc3)
					.padding(),

				# Label(desc3),
				# Label(desc3)
				# 	.fontSize(24)
				# 	.padding(),
				# PersonView("Elvis"),
			]),

			VBox([

				HBox([

					Image("res://icon.svg")
					.resize()
					.frame(60, 60)
					.stretchMode(View.StretchMode.KEEP_ASPECT_CENTERED)
					.background(Color.WEB_GRAY, 10)
					.frame(Infinity),

					Label(desc3)
						.fontSize(24)
						.padding()
						.frame(Infinity),

					Label(desc3)
						.fontSize(24),
				
				]),
				
				HBox([

					HBox([

						Image("res://icon.svg")
							.frame(Infinity),
						Image("res://icon.svg")
							.frame(Infinity),

					]).frame(Infinity),
					# TextEdit(desc3, "Aqui vamos!")
					# 	.frame(Infinity, Infinity),

				])
					.changeToVertical(should_vertical.value)
					.spacing(20),

				# ForEach(names, func(name):
				# 	return Label(name)),
			])
				.fontSize(18)
				.background(Color.BLACK.lightened(0.3), 10),
		])
		.frame(Infinity, Infinity),
	]

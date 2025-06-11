extends View
class_name FitContentExample

var fit = Binding.new(false)
var showlabels = Binding.new(false)
var text = Binding.new("Hi, this is a longer text that will use more space when is growing")

func configure():
	#Body is where all the UI elements are defined
	body = ZStack([


		VBox([

			HBox([
				Label("Frame value: " + ("Infinity" if fit.value else "Fit Content"))
					.fontSize(28)
					.bold(),
					
					
				Button("Toggle FitContent", func():
					fit.toggle()),

				Button("Show Labels", func():
					showlabels.toggle()),
			]),


			HBox([
				Button("Hello World")
					.padding()
					.background(Color('09f') if fit.value else Color.GRAY, 10)
					.frame(Infinity if fit.value else FitContent),

				Label(text)
					.visible(showlabels),

				(Label("This is a short text")
					.frame(Infinity if fit.value else FitContent)
					.visible(showlabels)

					if fit.value else

				Label("This is a short text")
					.visible(showlabels)),

			])
			.spacing(10),

			TextEdit(text, "type here")
				.frame(400, 300)
				.focus()
				.visible(showlabels),
		])
		.alignment(BoxContainerAlignment.BEGIN)
		.frame(FitContent, Infinity)
		.fontSize(22)

	])

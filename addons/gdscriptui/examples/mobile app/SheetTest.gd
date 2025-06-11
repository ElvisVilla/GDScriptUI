extends View
class_name SheetTest

var is_presented: Binding

func configure(isPresented: Binding):
	is_presented = isPresented
	# other properties here


	#Body is where all the UI elements are defined
	body = ZStack([

		VBox([

			HBox([
				Label(is_presented)
				.padding()
				.background(Color.RED)
				.fontSize(40),
				
				Button(" X ", func():
					is_presented.value = false)
				.fontSize(50),
			]),

		])
		.frame(Infinity, Infinity)
		.padding(16),
	])

extends View
class_name NewView

func configure(value: String, chill):
	body = ZStack([
		VBox([
			Label(value)
		])
	])

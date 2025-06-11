extends View
class_name HomeView

var shouldShowSheet = Binding.new(false)
var refresh = Binding.new(false)
var text_content = Binding.new("")
var scale_amount = Binding.new(1.0)

func configure():
	body = ZStack([

		#ProjectStudio Code

		GradientView([Color.BLACK]).frame(Infinity, Infinity)
			.ignoreSafeArea(),
		
		VBox([

			# Title View
			VBox([

				Label("Welcome Back!").bold()
					.fontSize(46),
				
				Label("Elvis Villavicencio").bold()
					.fontSize(30)
					.fontColor(Color.DARK_GRAY),
				
				Label("Projects").semiBold()
					.fontSize(36),
					
			])
			.spacing(4)
			.background(Color.DARK_GRAY, 10)
			.paddingSpecific(8, 8, 8, 24),

			Label(text_content),
			TextEdit(text_content, "Here").focus(),

			VBox([

				HBox([

					Label("Refresh value is: " + str(refresh.value)),
					Button("Refresh View", func():
						refresh.value = !refresh.value
						scale_amount.value += 0.3),

					Button("Present Sheet")
						.onPressed(func():
							shouldShowSheet.value = !shouldShowSheet.value)
						.scale(scale_amount)
						.animation(Flow.duration(0.5), scale_amount),
							 
				]),

				ProjectCard(),
				ProjectCard(),
				ProjectCard(),
				ProjectCard(),
			])
			.frame(Infinity, Infinity)
			.spacing(24),
		])
		.padding(16),

	], "body").frame(Infinity)


func ProjectCard(): return \
	VBox([
		#Title 
		Label("Project Studio").bold()
			.fontSize(36)
			.fontColor(Color('#EEBE04')),
		
		HBox([
			HBox([
				Image("res://images/clock.png")
					.resize().frame(20, 20),
				Label("9:24").fontSize(26),
			])
			.padding(0),
			
			Spacer(),
			
			Label("0").fontSize(26)
		]),
		
		Label("This project made in Godot Engine 4, using GDscriptUI, mimics Project Studio developed from SwiftUI, mobile application to track your work, notes and task done")
		.fontSize(19)
		.fontColor(Color.GRAY.darkened(0.2))
		.regular(),

	]) \
	.padding(16) \
	.background(Color('#262626'), 10)

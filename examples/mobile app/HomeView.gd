extends View
class_name HomeView

var paddingAmount = Binding.new(16.0)
var blurAmount = Binding.new(0.2)
var shouldShowSheet = Binding.new(false)
var shouldPresentHome = Binding.new(false)

var vis = Binding.new(true)

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
			.background(Color.DARK_GRAY, 10).blur(1.7)
			.paddingSpecific(8, 8, 8, 24).visible(false),

			VBox([

				HBox([

					Button("Animate Padding", func():
						blurAmount.value = 1.7
						vis.value = !vis.value)
					.padding(paddingAmount)
					.fontSize(28),

					Button("Present Sheet")
						.onPressed(func(): shouldShowSheet.value = !shouldShowSheet.value)
						.sheet(shouldShowSheet,
							SheetTest(shouldShowSheet)),
							 
				]),

				ProjectCard().blur(blurAmount),
				ProjectCard().blur(blurAmount),
				ProjectCard().blur(blurAmount),
				ProjectCard().blur(blurAmount),
			])
			.frame(Infinity, Infinity)
			.spacing(24),
		])
		.padding(paddingAmount),

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
	.padding(paddingAmount) \
	.background(Color('#262626'), 10)


	# ColorView(Color.BLACK).frame(Infinity, Infinity),
	# GradientView(
	# 	[Color('332D56'), Color('4E6688').lightened(0.3)],
	# 	Vector2(randf(), randf()),
	# 	Vector2(randf(), randf())
	# ).cornerRadius(10).frame(Infinity, Infinity),

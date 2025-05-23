extends Node
class_name View

signal property_changed(property_name, new_value)
var body: Array = []
var nestedViews: Dictionary = {}

## Does emit property_change Signal
func observe(property_name: String, value):
	property_changed.emit(property_name, value)

func to_parent(parent) -> ContainerBuilder:
	print(body[0] is ContainerBuilder)
	if body.size() > 0:
		if not body[0] is ContainerBuilder:
			return HBox(body).padding(16)._in_node(parent)
		else:
			return body[0].padding(16)._in_node(parent)
	
	return null


func build_ui(parent) -> ContainerBuilder:
	print(body[0] is ContainerBuilder)
	if body.size() > 0:
		if not body[0] is ContainerBuilder:
			return HBox(body).padding(16)
		else:
			return body[0].padding(16)
	
	return null

# Factory methods for container creation
func HBox(children: Array = [], description: String = "") -> ContainerBuilder:
	var builder = ContainerBuilder.new(children)
	return builder.horizontal(description)
	
func VBox(children: Array = [], description: String = "") -> ContainerBuilder:
	var builder = ContainerBuilder.new(children)
	return builder.vertical(description)

func ZStack(children: Array = [], _description: String = "") -> ZStackBuilder:
	var builder = ZStackBuilder.new(children)
	return builder

# Button cant define icon because icon sizing doesnt work properly as TextureRect sizing
# For adding icon inside of a Button is better to wrap a Image and Button inside of a BoxContainer 
## Button from GDScriptUI
func Button(_text: String) -> ButtonBuilder:
	return ButtonBuilder.new(_text)

func ForEach(items, action: Callable) -> ContainerBuilder:
	# In order to bind the UI node we have to build it first
	var hbox = HBox([])

	# This kind of looks efficient
	# What is not efficient is the way the property ContainerBuilder.children
	# Works, we are deleting child nodes and create them again.
	# Other frameworks like SwiftUI will work with ID
	if items is ObserveArray:
		# Bind to the container builder's children property
		items.bind(hbox._content_node, "children", func(new_items: Array):
			var new_elements = []
			for item in new_items:
				var element = action.call(item)
				if element != null:
					new_elements.append(element)
			hbox.children = new_elements
		)
	else:
		var result = []
		for item in items:
			var element = action.call(item)
			if element != null:
				result.append(element)

	return hbox


func Image(texture: String = "") -> TextureRectBuilder:
	return TextureRectBuilder.new(texture)

func Label(text) -> LabelBuilder:
	return LabelBuilder.new(text)

##Editor for Text
func TextEdit(text, place_holder: String) -> TextEditBuilder:
	return TextEditBuilder.new(text, place_holder)

func Spacer() -> SpacerBuilder:
	return SpacerBuilder.new()

func ColorView(color: Color) -> ColorBuilder:
	return ColorBuilder.new(color)

## Creates a gradient view with specified colors.
## - startPoint (0,0) -> (top-left corner)
## - endPoint (1,1) -> (bottom-right corner)
func GradientView(colors: Array[Color], startPoint: Vector2 = Vector2(0, 0), endPoint: Vector2 = Vector2(1, 1)) -> ColorBuilder:
	var texture = GradientTexture2D.new()
	texture.fill_from = startPoint
	texture.fill_to = endPoint
	texture.gradient = Gradient.new()
	texture.gradient.colors = colors
	
	var off_set = []
	for element in range(colors.size()):
		if element == 0:
			off_set.append(element)
			continue
			
		off_set.append(1.0 / element)
	texture.gradient.offsets = off_set
	return ColorBuilder.new(texture)

func bind(initial_value) -> Binding:
	return Binding.new(initial_value)


# Custom enums that mirror TextureRect's enums for better readability
enum ExpandMode {
	## The minimum size will be equal to texture size, TextureRect can't be smaller than the texture
	KEEP_SIZE = 0,
	## The size of the texture won't be considered for minimum size calculation
	IGNORE_SIZE = 1,
	## The height of the texture will be ignored; useful for horizontal layouts
	FIT_WIDTH_PROPORTIONAL = 3,
	## The width of the texture will be ignored; useful for vertical layouts
	FIT_HEIGHT = 4,
	## Same as FIT_HEIGHT but keeps texture's aspect ratio
	FIT_HEIGHT_PROPORTIONAL = 5,
}

enum StretchMode {
	## Scale (stretch) to fit the node's bounding rectangle
	SCALE = 0,
	## Tile the image inside the node's bounding rectangle
	TILE = 1,
	## The texture keeps its original size, is not counted for minimum size calculation inside the container
	KEEP = 2,
	## As with [Keep] the texture keeps its original size, is not counted for minimum size calculation inside the container
	KEEP_ASPECT = 4, # Scale the texture to fit the bounding rectangle while maintaining aspect ratio
	## Scale to fit, center it and maintain aspect ratio
	KEEP_ASPECT_CENTERED = 5,
	## Cover the entire bounding rectangle, aspect ratio is not maintained, the texture may be cropped
	KEEP_ASPECT_COVERED = 6,
}

##The SizeFlags constants goes like this, you could also use integers values
## 	SizeFlags {
## 		0 = SHRINK_BEGIN
## 		1 = FILL
## 		2 = EXPAND
## 		3 = EXPAND_FILL 
## 		4 = SHRINK_CENTER
## 		5 = SHRINK_END
## 	}
enum SizeFlags {
	SHRINK_BEGIN = Control.SIZE_SHRINK_BEGIN,
	FILL = Control.SIZE_FILL,
	EXPAND = Control.SIZE_EXPAND,
	EXPAND_FILL = Control.SIZE_EXPAND_FILL,
	SHRINK_CENTER = Control.SIZE_SHRINK_CENTER,
	SHRINK_END = Control.SIZE_SHRINK_END,
}

enum TextAlignment {
	TRAILING = 0,
	CENTER = 1,
	LEADING = 2,
	TOP = 0,
	BOTTOM = 2,
}

enum BoxContainerAlignment {
	BEGIN = 0,
	CENTER = 1,
	END = 2,
}


const Infinity = -1
const FitContent = -2

func set_nested_view(viewName: String, view: View):
	if not nestedViews.has(viewName):
		nestedViews[viewName] = view
		add_child(view, true)

func get_nested_view(viewName: String) -> View:
	return nestedViews[viewName]

func build_nested_view(viewName: String, view: View, parent: Node) -> ContainerBuilder:
	set_nested_view(viewName, view)
	# get_nested_view(viewName)._ready()
	return get_nested_view(viewName).build_ui(parent)


# BEGIN GENERATED VIEW FUNCTIONS

func AppUI(to_concert_with, person_name):
	var element = load("res://framework/views/App UI.gd").new()
	element.configure(to_concert_with, person_name) #constructor call
	return build_nested_view("AppUI", element, self)


func ContentView():
	var element = load("res://examples/ContentView.gd").new()
	return build_nested_view("ContentView", element, self)


func OtherView():
	var element = load("res://examples/OtherView.gd").new()
	element.configure() #constructor call
	return build_nested_view("OtherView", element, self)


func PersonView(person_name):
	var element = load("res://framework/views/PersonView.gd").new()
	element.configure(person_name) #constructor call
	return build_nested_view("PersonView", element, self)


func SimpleView():
	var element = load("res://examples/SimpleView.gd").new()
	return build_nested_view("SimpleView", element, self)


func ViewTest(message):
	var element = load("res://framework/views/ViewTest.gd").new()
	element.configure(message) #constructor call
	return build_nested_view("ViewTest", element, self)

# END GENERATED VIEW FUNCTIONS

extends Node
class_name View

signal property_changed(property_name, new_value)
@export var view_owner: Node
var body: Array = []
var nestedViews: Dictionary = {}

## Does emit property_change Signal
func observe(property_name: String, value):
	property_changed.emit(property_name, value)


func build_ui(parent) -> ContainerBuilder:
	#We se the child content here, we also must pass the view_owner to the child views
	var box: ContainerBuilder = null
	if body.size() > 0:
		box = VBox(body, name)._in_node(parent)
		view_owner = parent
		print("build_ui on parent: ", parent.name)
		return box
	
	return null

# Factory methods for container creation
func HBox(children: Array = [], description: String = "") -> ContainerBuilder:
	var builder = ContainerBuilder.new(children)
	return builder.horizontal(description)
	
func VBox(children: Array = [], description: String = "") -> ContainerBuilder:
	var builder = ContainerBuilder.new(children)
	return builder.vertical(description)


##Icon can be resized to fit the button
func Button(_text: String) -> ButtonBuilder:
	return ButtonBuilder.new(_text)

func ForEach(items, action: Callable):
	var result = []
	for item in items:
		var element = action.call(item)
		if element != null:
			result.append(element)
	
	return HBox(result, "ForEach")


func Image(texture: String = "") -> TextureRectBuilder:
	return TextureRectBuilder.new(texture)

func Label(text: String = "") -> LabelBuilder:
	return LabelBuilder.new(text)

func TextEdit(text: String, place_holder: String) -> TextEditBuilder:
	return TextEditBuilder.new(text, place_holder)

func Spacer() -> SpacerBuilder:
	return SpacerBuilder.new()


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

enum SizeFlags {
	SHRINK_BEGIN = Control.SIZE_SHRINK_BEGIN,
	FILL = Control.SIZE_FILL,
	EXPAND = Control.SIZE_EXPAND,
	EXPAND_FILL = Control.SIZE_EXPAND_FILL,
	SHRINK_CENTER = Control.SIZE_SHRINK_CENTER,
	SHRINK_END = Control.SIZE_SHRINK_END,
}


enum BoxContainerAlignment {
	BEGIN = 0,
	CENTER = 1,
	END = 2,
}

func set_nested_view(viewName: String, view: View):
	if not nestedViews.has(viewName):
		nestedViews[viewName] = view
		add_child(view, true)

func get_nested_view(viewName: String) -> View:
	return nestedViews[viewName]

func build_nested_view(viewName: String, view: View, parent: Node):
	set_nested_view(viewName, view)
	get_nested_view(viewName)._ready()
	return get_nested_view(viewName).build_ui(parent)


# BEGIN GENERATED VIEW FUNCTIONS

func AppUI(to_concert_with, person_name):
	var element = load("res://framework/views/App UI.gd").new()
	element.configure(to_concert_with, person_name) #constructor call
	return build_nested_view("App UI", element, self)


func ViewTest():
	var element = load("res://framework/views/ViewTest.gd").new()
	return build_nested_view("ViewTest", element, self)


func PersonView(person_name):
	var element = load("res://framework/views/PersonView.gd").new()
	element.configure(person_name) #constructor call
	return build_nested_view("PersonView", element, self)

# END GENERATED VIEW FUNCTIONS

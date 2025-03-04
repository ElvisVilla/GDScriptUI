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
		box = VBox(name, body).spacing(8).padding(8).in_node(parent)
		view_owner = parent
		print("build_ui on parent: ", parent.name)
		return box
	
	return null

# Factory methods for container creation
func HBox(description: String = "", children: Array = [], print: bool = false) -> ContainerBuilder:
	var builder = ContainerBuilder.new(children)

	if print:
		print("HBox description: ", description)
	return builder.horizontal(description)
	
func VBox(description: String = "", children: Array = []) -> ContainerBuilder:
	var builder = ContainerBuilder.new(children)
	return builder.vertical(description)

func Button(_text: String) -> ButtonBuilder:
	return ButtonBuilder.new(_text)

func ForEach(items, action: Callable):
	var result = []
	for item in items:
		var element = action.call(item)
		if element != null:
			result.append(element)
	
	return HBox("ForEach", result)


func Image(texture = null) -> TextureRectBuilder:
	return TextureRectBuilder.new(texture)

func Label(text: String = "") -> LabelBuilder:
	return LabelBuilder.new(text)


# Custom enums that mirror TextureRect's enums for better readability
enum ExpandMode {
	## The minimum size will be equal to texture size, TextureRect can't be smaller than the texture
	KEEP_SIZE = 0,
	IGNORE_SIZE = 1, # The size of the texture won't be considered for minimum size calculation
	FIT_WIDTH = 2, # The height of the texture will be ignored; useful for horizontal layouts
	FIT_WIDTH_PROPORTIONAL = 3, # Same as FIT_WIDTH but keeps texture's aspect ratio
	FIT_HEIGHT = 4, # The width of the texture will be ignored; useful for vertical layouts
	FIT_HEIGHT_PROPORTIONAL = 5 # Same as FIT_HEIGHT but keeps texture's aspect ratio
}

enum StretchMode {
	SCALE = 0, # Scale to fit the node's bounding rectangle
	TILE = 1, # Tile inside the node's bounding rectangle
	KEEP = 2, # The texture keeps its original size and stays in the top-left corner
	KEEP_CENTERED = 3, # The texture keeps its original size and stays centered
	KEEP_ASPECT = 4, # Scale the texture to fit the bounding rectangle while maintaining aspect ratio
	KEEP_ASPECT_CENTERED = 5, # Scale to fit, center it and maintain aspect ratio
	KEEP_ASPECT_COVERED = 6 # Scale so shorter side fits bounding rectangle, other side may clip
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

extends PanelContainer
class_name UIRoot

@export var content: View

var method_list = {}
var constructor = ""
var arguments = []
var my_methods: Array = []

func _ready():
	if content:
		content.build_ui(self)
		connect_all_views(content)

	# var child_node = get_child(0).get_child(0)
	# method_list = child_node.get_method_list()

	# #Get _method_contructor and arguments
	# for method in method_list:
	# 	if method.flags == METHOD_FLAG_NORMAL:
	# 		if method.name.begins_with("_"):
	# 			my_methods.append(method)
	# 		if method.name.begins_with("_init"):
	# 			constructor = method.name
	# 			arguments = method.args
	# 			print("Constructor: ", constructor, " Arguments: ", arguments)

func connect_all_views(node):
	if node is View:
		print("Connecting signal to: ", node.name)
		if !node.property_changed.is_connected(_on_property_changed):
			node.property_changed.connect(_on_property_changed)
	
	for child in node.get_children():
		connect_all_views(child)

func _on_property_changed(property_name, new_value):
	print("Property changed: ", property_name, " to ", new_value)
	rebuild_ui()


#Rebuild the whole UI including nested views
#Should rebuild based on the UI that changed
func rebuild_ui():
	# Remove all existing children FROM CONTENT
	for child in get_children():
		if child is Control:
			remove_child(child)
			child.queue_free()

	# CRUCIAL STEP: Regenerate the body content with current properties
	content._ready() # This will regenerate the body array with updated properties

	# Build UI again
	content.build_ui(self)

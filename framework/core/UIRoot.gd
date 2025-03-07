extends PanelContainer
class_name UIRoot

@export var content: View

func _ready():
	if content:
		content.build_ui(self)
		connect_all_views(content)

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

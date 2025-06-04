extends Control
class_name UIRoot

var spell_targets = 0
@onready var content: View = load("res://examples/mobile app/HomeView.gd").new()
@onready var safeArea = %"safeArea"

var modals = []

# TODO: Test %UIRoot access
func _enter_tree() -> void:
	name = "UIRoot"
	self.unique_name_in_owner = true

func _ready():
	if content:
		content.configure()
		content.to_parent(safeArea)
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
#TODO: Structure has changed, it should in fact erase everything from SafeArea (I think, need to test)
func rebuild_ui():
	# Remove all existing children FROM CONTENT
	for child in safeArea.get_children():
		if child is Control:
			remove_child(child)
			child.queue_free()

	# CRUCIAL STEP: Regenerate the body content with current properties
	content.configure() # This will regenerate the body array with updated properties

	# Build UI again
	content.to_parent(safeArea)


func dismiss():
	if not modals.is_empty():
		var modal = modals.pop_back() as Modal
		modal.dismiss()


func print_from_UIRoot():
	print("print_from_UIRoot")

extends Control
class_name GDScriptUIEntry

@export_file("*.gd") var content_script: String
var content: View
var safeArea: MarginContainer
var modals = []

func _enter_tree() -> void:
	name = "GDScriptUIEntry"
	self.unique_name_in_owner = true
	set_full_anchors(self)
	set_safe_area()

func _ready():
	if content_script:
		content = load(content_script).new()
		content.configure()
		content.to_parent(safeArea)

func rebuild_ui():
	# Remove all existing children FROM CONTENT
	for child in safeArea.get_children():
		if child:
			remove_child(child)
			child.queue_free()
	
	content.body = null

	# Build UI again
	content.configure()
	content.to_parent(safeArea)

func dismiss():
	if not modals.is_empty():
		var modal = modals.pop_back() as Modal
		modal.dismiss()

func set_safe_area():
	safeArea = MarginContainer.new()
	safeArea.name = "safeArea"
	safeArea.unique_name_in_owner = true

	set_full_anchors(safeArea)
	add_child(safeArea)

func set_full_anchors(node: Control):
	node.set_anchors_preset(Control.PRESET_FULL_RECT)
	node.anchor_left = 0.0
	node.anchor_top = 0.0
	node.anchor_right = 1.0
	node.anchor_bottom = 1.0

	node.offset_right = 0.0
	node.offset_bottom = 0.0

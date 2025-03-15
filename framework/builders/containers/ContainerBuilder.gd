extends BaseBuilder
class_name ContainerBuilder


var _children: Array = []

func _init(children: Array = []):
	_children = children # Store children for later use
	_margin_node = MarginContainer.new()
	_content_node = BoxContainer.new()
	_margin_node.add_child(_content_node)
	_with_margin(true)

	_add_children_to_container()

func _add_children_to_container():
	for child in _children:
		if child._get_parent_node().get_parent():
			child._get_parent_node().get_parent().remove_child(child._get_parent_node())
		_content_node.add_child(child._get_parent_node())

func horizontal(description: String = "") -> ContainerBuilder:
	if _content_node.get_parent() == _margin_node:
		_content_node.queue_free()
	_content_node = HBoxContainer.new()
	_content_node.alignment = View.BoxContainerAlignment.CENTER
	_margin_node.add_child(_content_node)
	_margin_node.name = description + " Margin Container"
	_content_node.name = description + " HBox Container"

	#spacing
	_content_node.set("theme_override_constants/separation", 8)

	#padding
	_content_node.add_theme_constant_override("margin_left", 8)
	_content_node.add_theme_constant_override("margin_right", 8)
	_content_node.add_theme_constant_override("margin_top", 8)
	_content_node.add_theme_constant_override("margin_bottom", 8)

	_add_children_to_container()
	return self
	
func vertical(description: String = "") -> ContainerBuilder:
	if _content_node.get_parent() == _margin_node:
		_content_node.queue_free()
	_content_node = VBoxContainer.new()
	_content_node.alignment = View.BoxContainerAlignment.CENTER
	_margin_node.add_child(_content_node)
	_margin_node.name = description + " Margin Container"
	_content_node.name = description + " VBox Container"
	
	#spacing
	_content_node.set("theme_override_constants/separation", 8)

	#padding
	_content_node.add_theme_constant_override("margin_left", 8)
	_content_node.add_theme_constant_override("margin_right", 8)
	_content_node.add_theme_constant_override("margin_top", 8)
	_content_node.add_theme_constant_override("margin_bottom", 8)

	_add_children_to_container()
	return self

func spacing(value: int) -> ContainerBuilder:
	_content_node.set("theme_override_constants/separation", value)
	return self

func alignment(alignment: View.BoxContainerAlignment) -> ContainerBuilder:
	_content_node.set("alignment", alignment)
	return self

func expand() -> ContainerBuilder:
	for child in _children:
		child._get_parent_node().set("size_flags_horizontal", View.SizeFlags.EXPAND)
		child._get_parent_node().set("size_flags_vertical", View.SizeFlags.EXPAND)
	return self

func expandFill() -> ContainerBuilder:
	_get_parent_node().set("size_flags_horizontal", View.SizeFlags.EXPAND_FILL)
	_get_parent_node().set("size_flags_vertical", View.SizeFlags.EXPAND_FILL)

	for child in _children:
		print("child name: ", child.name)
		child._get_parent_node().set("size_flags_horizontal", View.SizeFlags.EXPAND_FILL)
		child._get_parent_node().set("size_flags_vertical", View.SizeFlags.EXPAND_FILL)
	return self

func fontSize(font_size: int) -> ContainerBuilder:
	for child in _children:
		if child._has_explicit_modifier("fontSize"):
			continue
		
		print("Propagating font size to child: ", child._content_node.name)

		if child is ContainerBuilder and child._children.size() > 0:
			child.fontSize(font_size)

		if child.has_method("fontSize"):
			child.fontSize(font_size)
	return self

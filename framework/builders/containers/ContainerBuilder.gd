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
	_margin_node.add_child(_content_node)
	_margin_node.name = description + " Margin Container"
	_content_node.name = description + " HBox Container"
	# Re-add all children to the new container
	# for child in _children:
	# 	if child._get_parent_node().get_parent():
	# 		child._get_parent_node().get_parent().remove_child(child._get_parent_node())

	# 	_content_node.add_child(child._get_parent_node())
	_add_children_to_container()
	return self
	
func vertical(description: String = "") -> ContainerBuilder:
	if _content_node.get_parent() == _margin_node:
		_content_node.queue_free()
	_content_node = VBoxContainer.new()
	_margin_node.add_child(_content_node)
	_margin_node.name = description + " Margin Container"
	_content_node.name = description + " VBox Container"
	# Re-add all children to the new container
	# for child in _children:
	# 	if child._margin_node.get_parent():
	# 		child._margin_node.get_parent().remove_child(child._margin_node)
	# 	_container.add_child(child._margin_node)
	_add_children_to_container()
	return self

func spacing(value: int) -> ContainerBuilder:
	_content_node.set("theme_override_constants/separation", value)
	return self

# func padding(amount: int) -> ContainerBuilder:
# 	_margin_node.add_theme_constant_override("margin_left", amount)
# 	_margin_node.add_theme_constant_override("margin_right", amount)
# 	_margin_node.add_theme_constant_override("margin_top", amount)
# 	_margin_node.add_theme_constant_override("margin_bottom", amount)
# 	return self

# func showContent(value: bool = true) -> ContainerBuilder:
# 	_margin_node.visible = value
# 	return self


# func _in_node(parent: Node) -> ContainerBuilder:
# 	parent.add_child(_margin_node, true)
# 	return self

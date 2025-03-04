extends RefCounted
class_name ContainerBuilder

var _margin_node: MarginContainer
var _container: BoxContainer
var _children: Array = []

func _init(children: Array = []):
	_margin_node = MarginContainer.new()
	_container = BoxContainer.new()
	_margin_node.add_child(_container)
	_children = children # Store children for later use

func horizontal(description: String = "") -> ContainerBuilder:
	if _container.get_parent() == _margin_node:
		_container.queue_free()
	_container = HBoxContainer.new()
	_margin_node.add_child(_container)
	_margin_node.name = description
	_container.name = description + " Container"
	# Re-add all children to the new container
	for child in _children:
		if child._margin_node.get_parent():
			child._margin_node.get_parent().remove_child(child._margin_node)

			print("being removed: ", child._margin_node.name)
		_container.add_child(child._margin_node)
	return self
	
func vertical(description: String = "") -> ContainerBuilder:
	if _container.get_parent() == _margin_node:
		_container.queue_free()
	_container = VBoxContainer.new()
	_margin_node.add_child(_container)
	_margin_node.name = description
	_container.name = description + " Container"
	# Re-add all children to the new container
	for child in _children:
		if child._margin_node.get_parent():
			child._margin_node.get_parent().remove_child(child._margin_node)
		_container.add_child(child._margin_node)
	return self

func spacing(value: int) -> ContainerBuilder:
	_container.set("separation", value)
	return self

func padding(amount: int) -> ContainerBuilder:
	_margin_node.add_theme_constant_override("margin_left", amount)
	_margin_node.add_theme_constant_override("margin_right", amount)
	_margin_node.add_theme_constant_override("margin_top", amount)
	_margin_node.add_theme_constant_override("margin_bottom", amount)
	return self

func showContent(value: bool = true) -> ContainerBuilder:
	_margin_node.visible = value
	return self

func in_node(parent: Node) -> ContainerBuilder:
	parent.add_child(_margin_node, true)
	return self

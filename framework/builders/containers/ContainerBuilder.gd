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

# Here is the logic of the children being added to the container
func _add_children_to_container():
	for child in _children:
		if child._get_parent_node().get_parent():
			child._get_parent_node().get_parent().remove_child(child._get_parent_node())
		_content_node.add_child(child._get_parent_node())

	
	# for child in _children:
	# 	if child._has_explicit_modifier("sizeFlags"):
	# 		var modifier_name = child._explicit_modifiers.get("sizeFlags")
	# 		print_debug("child: ", child._content_node.name, "Attempting to modify parent: ", _content_node.name, " with modifier: ", modifier_name)
	# 		call(modifier_name)

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

	#padding to what, HBoxContainer doesnt have padding
	_margin_node.add_theme_constant_override("margin_left", 8)
	_margin_node.add_theme_constant_override("margin_right", 8)
	_margin_node.add_theme_constant_override("margin_top", 8)
	_margin_node.add_theme_constant_override("margin_bottom", 8)

	_add_children_to_container()

	#This is mean to modify container size flags if the child needs the parent to be expanded
	for child in _children:
		if child._has_explicit_modifier("sizeFlags"):
			var modifier_name = child._explicit_modifiers.get("sizeFlags")
			call(modifier_name)

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
	_margin_node.add_theme_constant_override("margin_left", 8)
	_margin_node.add_theme_constant_override("margin_right", 8)
	_margin_node.add_theme_constant_override("margin_top", 8)
	_margin_node.add_theme_constant_override("margin_bottom", 8)

	_add_children_to_container()
	_call_child_explicit_size_modifier()

	return self

func spacing(value: int = 8) -> ContainerBuilder:
	_content_node.set("theme_override_constants/separation", value)
	return self

func alignment(alignment: View.BoxContainerAlignment) -> ContainerBuilder:
	_content_node.set("alignment", alignment)
	return self

func fontSize(font_size: int) -> ContainerBuilder:
	for child in _children:
		if child._has_explicit_modifier("fontSize"):
			continue

		if child is ContainerBuilder and child._children.size() > 0:
			child.fontSize(font_size)

		if child.has_method("fontSize"):
			child.fontSize(font_size)
	return self

# By Default Godot does fill content.
# GDscriptUI intent to work as Fit Content (Shrink at content size)
# This method propagates from the child to the parent recursively.
# When child calls expand modifiers, this method explicitly set a modifier on the dictionary.
# We are getting the name of the function the child called, and we called as well on the parent.
# If the expands, the parents will also expand.
func _call_child_explicit_size_modifier():
	for child in _children:
		if child._has_explicit_modifier("sizeFlags"):
			var modifier_name = child._explicit_modifiers.get("sizeFlags")
			
			#If we call the method, we are also setting a modifier on this container builder
			#That makes this function recursive
			call(modifier_name)
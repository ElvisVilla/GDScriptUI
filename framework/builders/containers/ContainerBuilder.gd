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
			
			#ON here we are calling the same modifier on the container,
			#This sets a explicit modifier on the container builder
			#And that makes this function recursive
			call(modifier_name)

# By Default Godot UI works with fill content.
# GDscriptUI intent to work as Fit Content (ShrinkCenter at content size)
# this method checks if the child has requested the parent to expand with the .frame(width: Infinity, height: Infinity)
# inside .frame() modifier we set true or false on _explicit_modifiers("expand_horizontal" or "expand_vertical") that means 
# on this ContainerBuilder based on child requirement we set a explicit modifier when calling frame(value, value)
# with that making a chain of propagation from bottom to top
func _check_explicit_modifier():
	for child in _children:
		var expand_horizontal_requested = child._explicit_modifiers.get("expand_horizontal", false)
		var expand_vertical_requested = child._explicit_modifiers.get("expand_vertical", false)

		var should_expand = false

		# Default sizing on GDscriptUI
		var horizontal_value = View.FitContent
		var vertical_value = View.FitContent

		# _get_parent_node is a helper function that retuns the outermost node of the BuilderContainer
		var is_parent_already_expanded_horizontally = _get_parent_node().size_flags_horizontal == View.SizeFlags.EXPAND_FILL
		var is_parent_already_expanded_vertically = _get_parent_node().size_flags_vertical == View.SizeFlags.EXPAND_FILL

		# if Outermost node in this container is not expanded this means we need to expand this container on width
		if expand_horizontal_requested and not is_parent_already_expanded_horizontally:
			should_expand = true
			horizontal_value = View.Infinity

		#if Outermost node in this container is not expanded this means we need to expand this container on height
		if expand_vertical_requested and not is_parent_already_expanded_vertically:
			should_expand = true
			vertical_value = View.Infinity

		# If custom sizing was defined on this container we drop propagation 
		if _get_parent_node().custom_minimum_size != Vector2.ZERO:
			should_expand = false

		# Perform chain of propagation
		if should_expand:
			print("should expand: ", _content_node.name)
			frame(horizontal_value, vertical_value)

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
	_check_explicit_modifier()
	_label_expand_horizontal()
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
	_check_explicit_modifier()
	_label_expand_horizontal()
	return self

func spacing(value: int = 8) -> ContainerBuilder:
	_content_node.set("theme_override_constants/separation", value)
	return self

func alignment(alignment: View.BoxContainerAlignment) -> ContainerBuilder:
	_content_node.set("alignment", alignment)
	return self

func fontSize(font_size: int) -> ContainerBuilder:
	for child in _children:
		# if a child has already set a fontSize modifier, we skip it
		if child._has_explicit_modifier("fontSize"):
			continue

		# If one child is also a container, we make a recursive call to propagate down
		if child is ContainerBuilder and child._children.size() > 0:
			child.fontSize(font_size)

		if child.has_method("fontSize"):
			child.fontSize(font_size)
	return self

func background(color: Color, radius: int = 0) -> ContainerBuilder:
	super.background(color, radius)

	_check_explicit_modifier()

	return self

func changeToVertical(value: bool) -> ContainerBuilder:
	if value:
		return self.vertical()
	else:
		return self.horizontal()


func _label_expand_horizontal() -> ContainerBuilder:
	var highest_ratio = 0.0

	for child in _children:
		if child._has_explicit_modifier("ratio"):
			print("node: ", child._content_node.name, " has ratio: ", child._explicit_modifiers.get("ratio"))
			highest_ratio = max(highest_ratio, child._explicit_modifiers.get("ratio"))

	for label_child in _children:
		if label_child._has_explicit_modifier("label_expand_ratio"):
			print("node: ", label_child._content_node.name, " has ratio: ", label_child._explicit_modifiers.get("label_expand_ratio"))
			label_child._content_node.size_flags_stretch_ratio = highest_ratio

	return self

extends BaseBuilder
class_name ContainerBuilder

#Builders Array, each builder construct itself from inside
var _children: Array = []
var _max_child_stretch_ratio: float = 1.0

var children: Array:
	set(new_children):
		_children = new_children
		for child in _content_node.get_children():
			child.queue_free()
		_add_children_to_container()
		_check_explicit_modifier()
		_check_custom_stretch_ratio()
		_check_ignore_safe_area_modifier()
		print_debug("Children Prorperty Being called from Container: ", _get_parent_node().name)
	get:
		return _children

func _init(children: Array = []):
	_children = children # Store children for later use
	_margin_node = MarginContainer.new()
	_content_node = BoxContainer.new()
	_margin_node.add_child(_content_node)
	_with_margin(true)

	_add_children_to_container()

func _add_children_to_container():
	for child in _children:
		#This lines where made with the intention of replace HBox or Vbox on BoxContainer
		if child._get_parent_node().get_parent():
			child._get_parent_node().get_parent().remove_child(child._get_parent_node())
		_content_node.add_child(child._get_parent_node())
		child.direct_container_builder = self

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

		# _get_parent_node() is a helper function that retuns the outermost node of the Builder
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

		# If custom sizing was defined on this container we drop propagation by setting should expand to false
		if _get_parent_node().custom_minimum_size != Vector2.ZERO:
			should_expand = false

		# Perform chain of propagation
		if should_expand:
			print_debug("should expand: ", _content_node.name)
			frame(horizontal_value, vertical_value)


func _check_ignore_safe_area_modifier():
	for child in _children:
		if child._explicit_modifiers.get("ignore_safe_area"):
			_explicit_modifiers.set("ignore_safe_area", true)

func horizontal(description: String = "") -> ContainerBuilder:
	# if _content_node.get_parent() == _margin_node:
	# 	_content_node.queue_free()
	# _content_node = HBoxContainer.new()
	_content_node.vertical = false
	_content_node.alignment = View.BoxContainerAlignment.CENTER
	# _margin_node.add_child(_content_node)
	_margin_node.name = description + " Margin Container"
	_content_node.name = description + " HBox Container"

	#spacing
	_content_node.set("theme_override_constants/separation", 8)

	#padding to what, HBoxContainer doesnt have padding
	_margin_node.add_theme_constant_override("margin_left", 8)
	_margin_node.add_theme_constant_override("margin_right", 8)
	_margin_node.add_theme_constant_override("margin_top", 8)
	_margin_node.add_theme_constant_override("margin_bottom", 8)

	# _add_children_to_container()
	_check_explicit_modifier()
	_check_custom_stretch_ratio()
	_check_ignore_safe_area_modifier()
	return self
	
func vertical(description: String = "") -> ContainerBuilder:
	# if _content_node.get_parent() == _margin_node:
	# 	_content_node.queue_free()
	# _content_node = VBoxContainer.new()
	_content_node.vertical = true
	_content_node.alignment = View.BoxContainerAlignment.CENTER
	# _margin_node.add_child(_content_node)
	_margin_node.name = description + " Margin Container"
	_content_node.name = description + " VBox Container"
	
	#spacing
	_content_node.set("theme_override_constants/separation", 8)

	#padding
	_margin_node.add_theme_constant_override("margin_left", 8)
	_margin_node.add_theme_constant_override("margin_right", 8)
	_margin_node.add_theme_constant_override("margin_top", 8)
	_margin_node.add_theme_constant_override("margin_bottom", 8)

	# _add_children_to_container()
	_check_explicit_modifier()
	_check_custom_stretch_ratio()
	_check_ignore_safe_area_modifier()
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

# Needs a Binding to reflect the change
func changeToVertical(value: bool) -> ContainerBuilder:
	if value:
		return self.vertical()
	else:
		return self.horizontal()


func _check_custom_stretch_ratio() -> ContainerBuilder:
	var highest_ratio = 1.0

	# Find highest ratio from any label
	for child in _children:
		if child._has_explicit_modifier("ratio"):
			highest_ratio = max(highest_ratio, child._explicit_modifiers.get("ratio"))

	# Apply to explicit label expansions
	for child in _children:
		# Because all labels expand by default because of (autowrap behaviour and fit content behaviour), if a label wants 
		# to expand, because it is already expanded, in order to fight for space we need to set his aspect equal to the biggest
		# brother in the container.
		if child is LabelBuilder:
			if child._has_explicit_modifier("label_expand_ratio"):
				# the stretch_ratio needs to also be applied to padding, backgroun, margin
				child._aspect_ratio_based_on_label_siblings(highest_ratio)

			else:
				continue
			
		# # NEW: Also apply to any element requesting expansion
		# We are obtaining the highest ratio and apply it even on containers that should not be applied a different ratio that what they already have
		# This code is adjusting child builders per container container builder, 
		elif (child._has_explicit_modifier("expand_horizontal") or child._has_explicit_modifier("expand_vertical")):
			child._aspect_ratio_based_on_label_siblings(highest_ratio)

		print_debug("label_expand_horizontal, highest ratio: ", highest_ratio)

	return self

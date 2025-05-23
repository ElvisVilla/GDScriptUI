extends BaseBuilder
class_name ZStackBuilder

var _children: Array = []

func _init(children: Array = []):
	_children = children
	_content_node = PanelContainer.new()
	_content_node.name = "ZStack"
	
	# Set up the content node to fill its parent
	_content_node.size_flags_horizontal = View.SizeFlags.SHRINK_CENTER
	_content_node.size_flags_vertical = View.SizeFlags.SHRINK_CENTER
	
	# Add children to the stack
	_add_children_to_stack()
	_check_explicit_modifier()
	_check_ignore_safe_area_modifier()

func _add_children_to_stack():
	for child in _children:
		if child._get_parent_node().get_parent():
			child._get_parent_node().get_parent().remove_child(child._get_parent_node())
		_content_node.add_child(child._get_parent_node())
		# child.direct_container_builder = self

# Override children property to handle updates
var children: Array:
	set(new_children):
		_children = new_children
		for child in _content_node.get_children():
			child.queue_free()
		_add_children_to_stack()
		_check_explicit_modifier()
		_check_ignore_safe_area_modifier()
	get:
		return _children

# Check if any child needs expansion
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

# Override frame to handle ZStack specific sizing
# func frame(width: int = View.FitContent, height: int = View.FitContent) -> ZStackBuilder:
# 	super.frame(width, height)
# 	return self

# Override background to handle ZStack specific styling
# func background(color: Color, corner_radius: int = 0) -> ZStackBuilder:
# 	super.background(color, corner_radius)
# 	return self

# Override padding to handle ZStack specific spacing
# func padding(amount = 8) -> ZStackBuilder:
# 	super.padding(amount)
# 	return self

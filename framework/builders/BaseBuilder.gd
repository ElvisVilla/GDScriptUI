extends RefCounted
class_name BaseBuilder

var _explicit_modifiers = {}
var _content_node: Control # The actual control being built (Button, Label, etc.)
var _margin_node: MarginContainer # Optional margin wrapper
var _panel_node: PanelContainer # Optional panel background wrapper
var _panel_margin_node: MarginContainer # Optional panel and margin wrapper
var _use_margin: bool = false # Flag to determine if we're using margin
var _use_panel: bool = false # Flag to determine if we're using panel background
var _use_panel_margin: bool = false # Flag to determine if we're using panel and margin
var builder_parent: Node

func _init():
	pass
	
# Creates and configures the margin container if needed
func _setup_margin_if_needed():
	if _use_margin and not _margin_node:
		_margin_node = MarginContainer.new()
		_margin_node.size_flags_horizontal = View.SizeFlags.FILL
		_margin_node.size_flags_vertical = View.SizeFlags.FILL

		if _content_node.get_parent():
			var parent = _content_node.get_parent()
			parent.remove_child(_content_node)
			parent.add_child(_margin_node)
			_margin_node.add_child(_content_node)
		else:
			_margin_node.add_child(_content_node)

func _setup_panel_margin_if_needed():
	if _use_panel_margin and not _panel_margin_node:
		_panel_margin_node = MarginContainer.new()
		_panel_margin_node.size_flags_horizontal = View.SizeFlags.FILL
		_panel_margin_node.size_flags_vertical = View.SizeFlags.FILL
		
		# Now reparent the panel into the panel margin
		if _panel_node.get_parent():
			var parent = _panel_node.get_parent()
			parent.remove_child(_panel_node)
			parent.add_child(_panel_margin_node)
			_panel_margin_node.add_child(_panel_node)
		else:
			_panel_margin_node.add_child(_panel_node)


# Creates and configures the panel container if needed
func _setup_panel_if_needed():
	if _use_panel and not _panel_node:
		_panel_node = PanelContainer.new()
		_panel_node.size_flags_horizontal = View.SizeFlags.SHRINK_CENTER
		_panel_node.size_flags_vertical = View.SizeFlags.SHRINK_CENTER
		
		# If we already have a margin, place the panel outside the margin
		if _use_margin and _margin_node:
			if _margin_node.get_parent():
				var parent = _margin_node.get_parent()
				parent.remove_child(_margin_node)
				parent.add_child(_panel_node)
				_panel_node.add_child(_margin_node)
			else:
				_panel_node.add_child(_margin_node)
		# Otherwise, place the panel directly around the content
		elif _content_node.get_parent():
			var parent = _content_node.get_parent()
			parent.remove_child(_content_node)
			parent.add_child(_panel_node)
			_panel_node.add_child(_content_node)
		else:
			_panel_node.add_child(_content_node)

## Gets the node that should be added to the parent
func _get_parent_node() -> Control:
	if _use_panel_margin:
		return _panel_margin_node
	elif _use_panel:
		return _panel_node
	elif _use_margin:
		return _margin_node
	else:
		return _content_node

func _with_panel_margin(enable: bool = true) -> BaseBuilder:
	_use_panel_margin = enable
	_setup_panel_margin_if_needed()
	return self

# Toggle margin container usage
func _with_margin(enable: bool = true) -> BaseBuilder:
	_use_margin = enable
	_setup_margin_if_needed()
	return self

# Add to parent node
func _in_node(parent: Node) -> BaseBuilder:
	parent.add_child(_get_parent_node())
	builder_parent = parent
	return self

# Visibility control
func visible(value: bool = true) -> BaseBuilder:
	_get_parent_node().visible = value
	return self

# Size control
func size(width: int, height: int) -> BaseBuilder:
	_content_node.custom_minimum_size = Vector2(width, height)
	return self

# Name setting (applies to both the main node and the margin if present)
func name(value: String) -> BaseBuilder:
	_content_node.name = value
	if _use_margin and _margin_node:
		_margin_node.name = value + " Container"
	if _use_panel and _panel_node:
		_panel_node.name = value + " Panel"
	return self

# Focus control
func focusable(value: bool = true) -> BaseBuilder:
	_content_node.focus_mode = Control.FOCUS_ALL if value else Control.FOCUS_NONE
	return self

# Tooltip
func tooltip(text: String) -> BaseBuilder:
	_content_node.tooltip_text = text
	return self

# Mouse filter
func mouseFilter(filter: Control.MouseFilter) -> BaseBuilder:
	_content_node.mouse_filter = filter
	return self


func padding(amount: int = 8) -> BaseBuilder:
	if _use_panel and not _use_panel_margin:
		# Automatically enable panel margin if padding is requested after background
		_use_panel_margin = true
		_setup_panel_margin_if_needed()
		
		_panel_margin_node.add_theme_constant_override("margin_left", amount)
		_panel_margin_node.add_theme_constant_override("margin_right", amount)
		_panel_margin_node.add_theme_constant_override("margin_top", amount)
		_panel_margin_node.add_theme_constant_override("margin_bottom", amount)

		_outer_frame_if_needed()

		return self
	
	if not _use_margin:
		# For padding before background, enable regular margin
		_with_margin(true)
	
	_margin_node.add_theme_constant_override("margin_left", amount)
	_margin_node.add_theme_constant_override("margin_right", amount)
	_margin_node.add_theme_constant_override("margin_top", amount)
	_margin_node.add_theme_constant_override("margin_bottom", amount)

	_outer_frame_if_needed()

	return self
	
# Set specific padding values
func paddingSpecific(left: int = 0, top: int = 0, right: int = 0, bottom: int = 0) -> BaseBuilder:
	if _use_panel and not _use_panel_margin:
		# Automatically enable panel margin if padding is requested after background
		_use_panel_margin = true
		_setup_panel_margin_if_needed()
		
		_panel_margin_node.add_theme_constant_override("margin_left", left)
		_panel_margin_node.add_theme_constant_override("margin_right", right)
		_panel_margin_node.add_theme_constant_override("margin_top", top)
		_panel_margin_node.add_theme_constant_override("margin_bottom", bottom)

		if _explicit_modifiers.has("expand_horizontal") and _explicit_modifiers.get("expand_horizontal"):
			_panel_margin_node.size_flags_horizontal = View.SizeFlags.FILL
		
		if _explicit_modifiers.has("expand_vertical") and _explicit_modifiers.get("expand_vertical"):
			_panel_margin_node.size_flags_vertical = View.SizeFlags.FILL

		return self

	if not _use_margin:
		# Automatically enable margin if padding is requested
		_with_margin(true)
	
	_margin_node.add_theme_constant_override("margin_left", left)
	_margin_node.add_theme_constant_override("margin_top", top)
	_margin_node.add_theme_constant_override("margin_right", right)
	_margin_node.add_theme_constant_override("margin_bottom", bottom)

	if _explicit_modifiers.has("expand_horizontal") and _explicit_modifiers.get("expand_horizontal"):
		_margin_node.size_flags_horizontal = View.SizeFlags.FILL
		
	if _explicit_modifiers.has("expand_vertical") and _explicit_modifiers.get("expand_vertical"):
		_margin_node.size_flags_vertical = View.SizeFlags.FILL

	return self

##The SizeFlags constants goes like this, you could also use integers values
## 	SizeFlags {
## 		SHRINK_BEGIN = 0,
## 		FILL = 1,
## 		EXPAND = 2,
## 		EXPAND_FILL = 3, 
## 		SHRINK_CENTER = 4,
## 		SHRINK_END = 5,
## 	}
func _sizeFlags(size_flags_h := View.SizeFlags.FILL, size_flags_v := View.SizeFlags.FILL) -> BaseBuilder:
	_get_parent_node().size_flags_horizontal = size_flags_h
	_get_parent_node().size_flags_vertical = size_flags_v
	return self

# Customize panel background color
func background(color: Color, corner_radius: int = 0) -> BaseBuilder:
	if not _use_panel:
		_use_panel = true
		_setup_panel_if_needed()
	
	var style = StyleBoxFlat.new()
	style.bg_color = color
	#corner_radius
	style.corner_radius_top_left = corner_radius
	style.corner_radius_top_right = corner_radius
	style.corner_radius_bottom_left = corner_radius
	style.corner_radius_bottom_right = corner_radius
	_panel_node.add_theme_stylebox_override("panel", style)

	_outer_frame_if_needed()

	return self

#TODO: Test frame modifier for each control View
func frame(width: int = View.FitContent, height: int = View.FitContent) -> BaseBuilder:
	# Fit content is by default the so no need to change anything.
	if width == View.FitContent and height == View.FitContent:
		return

	# if either width or height is View.Infinity we then expand and set explicit modifier for parent to respect this sizing.
	if width == View.Infinity:
		_content_node.size_flags_horizontal = View.SizeFlags.FILL

		if _margin_node:
			_margin_node.size_flags_horizontal = View.SizeFlags.FILL

		if _panel_node:
			_panel_node.size_flags_horizontal = View.SizeFlags.FILL

		if _panel_margin_node:
			_panel_node.size_flags_horizontal = View.SizeFlags.FILL

		_get_parent_node().size_flags_horizontal = View.SizeFlags.EXPAND_FILL
		_explicit_modifiers["expand_horizontal"] = true

	if height == View.Infinity:
		_content_node.size_flags_vertical = View.SizeFlags.FILL

		if _margin_node:
			_margin_node.size_flags_vertical = View.SizeFlags.FILL

		if _panel_node:
			_panel_node.size_flags_vertical = View.SizeFlags.FILL

		if _panel_margin_node:
			_panel_node.size_flags_vertical = View.SizeFlags.FILL

		_get_parent_node().size_flags_vertical = View.SizeFlags.EXPAND_FILL
		_explicit_modifiers["expand_vertical"] = true

	# custom size only modify the element that call frame, and because we are following FitContent (shrink_center) design
	# the parent will grow based on the custom_minimum_size of the childs
	if width >= 0:
		_get_parent_node().size_flags_horizontal = View.SizeFlags.SHRINK_CENTER
		_get_parent_node().custom_minimum_size.x = width

	if height >= 0:
		_get_parent_node().size_flags_vertical = View.SizeFlags.SHRINK_CENTER
		_get_parent_node().custom_minimum_size.y = height

	return self

func _internal_frame(width: int = View.FitContent, height: int = View.FitContent):
	# Fit content is by default the so no need to change anything.
	if width == View.FitContent and height == View.FitContent:
		return

	# if either width or height is View.Infinity we then expand and set explicit modifier for parent to respect this sizing.
	if width == View.Infinity:
		_content_node.size_flags_horizontal = View.SizeFlags.FILL

		if _margin_node:
			_margin_node.size_flags_horizontal = View.SizeFlags.FILL

		if _panel_node:
			_panel_node.size_flags_horizontal = View.SizeFlags.FILL

		if _panel_margin_node:
			_panel_node.size_flags_horizontal = View.SizeFlags.FILL

		_get_parent_node().size_flags_horizontal = View.SizeFlags.EXPAND_FILL
		_explicit_modifiers["expand_horizontal"] = true

	if height == View.Infinity:
		_content_node.size_flags_vertical = View.SizeFlags.FILL

		if _margin_node:
			_margin_node.size_flags_vertical = View.SizeFlags.FILL

		if _panel_node:
			_panel_node.size_flags_vertical = View.SizeFlags.FILL

		if _panel_margin_node:
			_panel_node.size_flags_vertical = View.SizeFlags.FILL

		_get_parent_node().size_flags_vertical = View.SizeFlags.EXPAND_FILL
		_explicit_modifiers["expand_vertical"] = true

	# custom size only modify the element that call frame, and because we are following FitContent (shrink_center) design
	# the parent will grow based on the custom_minimum_size of the childs
	if width >= 0:
		_get_parent_node().size_flags_horizontal = View.SizeFlags.SHRINK_CENTER
		_get_parent_node().custom_minimum_size.x = width

	if height >= 0:
		_get_parent_node().size_flags_vertical = View.SizeFlags.SHRINK_CENTER
		_get_parent_node().custom_minimum_size.y = height

func _outer_frame_if_needed():
	if _explicit_modifiers.has("expand_horizontal") or _explicit_modifiers.has("expand_vertical"):
		var should_expand = false
		var should_expand_horizontal = _explicit_modifiers.get("expand_horizontal", false)
		var should_expand_vertical = _explicit_modifiers.get("expand_vertical", false)
		var horizontal_value = View.FitContent
		var vertical_value = View.FitContent

		if should_expand_horizontal:
			should_expand = true
			horizontal_value = View.Infinity

		if should_expand_vertical:
			should_expand = true
			vertical_value = View.Infinity
			
		if should_expand:
			frame(horizontal_value, vertical_value)

func onMouseEntered(callback: Callable) -> BaseBuilder:
	_content_node.mouse_entered.connect(callback)
	return self

func onMouseExited(callback: Callable) -> BaseBuilder:
	_content_node.mouse_exited.connect(callback)
	return self

func onPressed(callback: Callable) -> BaseBuilder:
	_content_node.mouse_filter = Control.MOUSE_FILTER_STOP

	if _content_node is Label:
		_content_node.add_theme_color_override("font_color", Color(0.0, 0.0, 0.933).lightened(0.6))

	var press_handler = func(event: InputEvent):
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == false:
				# Only trigger on release inside the control
				callback.call()

	_content_node.gui_input.connect(press_handler)
	return self

func _has_explicit_modifier(modifier: String) -> bool:
	return _explicit_modifiers.has(modifier)

func _add_explicit_modifier(modifier: String, value: bool) -> BaseBuilder:
	_explicit_modifiers[modifier] = value
	return self

extends BaseBuilder
class_name LabelBuilder

var ratio: float = 1.0
# var text: Variant # Could be String or Binding

@warning_ignore("shadowed_variable")
func _init(text):
	_content_node = Label.new()
	_content_node.set_meta("LabelBuilder", self)

	# text = value

	if text is Binding:
		_bind_text(text)
		_content_node.tree_exiting.connect(func():
			text.unbind(_content_node, "text"))
	else:
		_content_node.text = text

	align()
	autowrap(TextServer.AUTOWRAP_WORD_SMART)

func fontSize(font_size: int) -> LabelBuilder:
	_content_node.add_theme_font_size_override("font_size", font_size)
	_add_explicit_modifier("fontSize", font_size)
	return self

func align(horizontal: View.TextAlignment = View.TextAlignment.LEADING, vertical: View.TextAlignment = View.TextAlignment.LEADING) -> LabelBuilder:
	_content_node.horizontal_alignment = horizontal
	_content_node.vertical_alignment = vertical
	return self

func autowrap(mode: TextServer.AutowrapMode) -> LabelBuilder:
	_content_node.autowrap_mode = mode

	_frame(View.Infinity)
	_calculate_stretch_ratio()
	

	return self

func frame(width: int = View.FitContent, height: int = View.FitContent):
	super.frame(width, height)

	_explicit_modifiers["label_expand_ratio"] = ratio
	return self

func _bind_text(binding: Binding):
	var label = _content_node as Label
	binding.bind(label, "text", func(new_value):
		label.text = str(new_value)
		_calculate_stretch_ratio()
		if direct_container_builder:
			direct_container_builder._check_custom_stretch_ratio()
		# var direct_container : BoxContainer = _get_parent_node().get_parent()
		) # calculate stretch ratio when text is being set

func _calculate_stretch_ratio():
	var font = _content_node.get_theme_default_font()
	if not font:
		font = _content_node.get_theme_font("font")
		
	if font:
		var font_size = _content_node.get_theme_font_size("font_size")
		var text_size = font.get_string_size(_content_node.text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, TextServer.DIRECTION_LTR)
		
		# Calculate ratio based on text width
		# This ensures longer text gets proportionally more space
		# We use a minimum of 1.0 to prevent very short text from being squished
		var text_length = text_size.x
		ratio = text_length / 100.0
		ratio = clamp(ratio, 0.4, 6.0)
		# ratio = max(text_length / 110.0, 1.0)
		

		_explicit_modifiers["ratio"] = ratio

		_content_node.size_flags_stretch_ratio = ratio
		if _margin_node != null:
			_margin_node.size_flags_stretch_ratio = ratio


		if _panel_node != null:
			_panel_node.size_flags_stretch_ratio = ratio

		if _panel_margin_node != null:
			_panel_margin_node.size_flags_stretch_ratio = ratio

	return self

# func _notification(what: int) -> void:
# 	if what == NOTIFICATION_PREDELETE:
# 		if text is Binding and _content_node:
# 			text.unbind(_content_node, "text")

func fontColor(color: Color) -> LabelBuilder:
	_content_node.add_theme_color_override("font_color", color)
	return self

func regular() -> LabelBuilder:
	_content_node.add_theme_font_override("font", load("res://framework/themes/SF Pro Fonts/regular_variation.tres"))
	return self

func medium() -> LabelBuilder:
	_content_node.add_theme_font_override("font", load("res://framework/themes/SF Pro Fonts/medium_variation.tres"))
	return self

func semiBold() -> LabelBuilder:
	_content_node.add_theme_font_override("font", load("res://framework/themes/SF Pro Fonts/semi_bold_variation.tres"))
	return self

func bold() -> LabelBuilder:
	_content_node.add_theme_font_override("font", load("res://framework/themes/SF Pro Fonts/bold_variantion.tres"))
	return self

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		print("Object being deleted: LabelBuilder")
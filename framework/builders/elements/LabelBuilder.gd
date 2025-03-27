extends BaseBuilder
class_name LabelBuilder

var ratio: float = 1.0
var should_skipp_modifier: bool = true

@warning_ignore("shadowed_variable")
func _init(text: String = ""):
	_content_node = Label.new()
	_content_node.text = text
	_content_node.name = text + "_label"

	align()
	autowrap(TextServer.AUTOWRAP_WORD_SMART)

func fontSize(font_size: int) -> LabelBuilder:
	_content_node.add_theme_font_size_override("font_size", font_size)
	_add_explicit_modifier("fontSize", font_size)
	return self

func align(horizontal: View.TextAlignment = View.TextAlignment.CENTER, vertical: View.TextAlignment = View.TextAlignment.CENTER) -> LabelBuilder:
	_content_node.horizontal_alignment = horizontal
	_content_node.vertical_alignment = vertical
	return self

func autowrap(mode: TextServer.AutowrapMode) -> LabelBuilder:
	_content_node.autowrap_mode = mode

	_internal_frame(View.Infinity)
	# frame(View.Infinity)
	_calculate_stretch_ratio()

	return self

func frame(width: int = View.FitContent, height: int = View.FitContent):
	super.frame(width, height)

	# if should_skipp_modifier:
	# 	print_debug("modifier skipped: ", should_skipp_modifier)
	# 	should_skipp_modifier = false
	# 	return self

	_explicit_modifiers["label_expand_ratio"] = ratio
	# print_debug("modifier not skipped: ", should_skipp_modifier)
	return self

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
		ratio = max(text_length / 100.0, 1.0)
		
		_content_node.size_flags_stretch_ratio = ratio
		_explicit_modifiers["ratio"] = ratio


	return self


# func _fit_content() -> LabelBuilder:
# 	_content_node.size_flags_horizontal = View.SIZE_EXPAND_FILL
# 	_content_node.size_flags_vertical = View.SIZE_EXPAND_FILL

# 	return self

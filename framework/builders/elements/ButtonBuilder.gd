extends BaseBuilder
class_name ButtonBuilder

var button_style_box = StyleBoxFlat.new()

func _init(_text: String):
	_content_node = Button.new()
	_content_node.name = _text + " Button"
	_content_node.text = _text
	_get_parent_node().size_flags_horizontal = View.SizeFlags.SHRINK_CENTER
	_get_parent_node().size_flags_vertical = View.SizeFlags.SHRINK_CENTER

func text(value: String) -> ButtonBuilder:
	_content_node.text = value
	return self

func fontSize(font_size: int) -> ButtonBuilder:
	_content_node.add_theme_font_size_override("font_size", font_size)
	_add_explicit_modifier("fontSize", font_size)
	return self

func onPressed(callback: Callable) -> ButtonBuilder:
	_content_node.pressed.connect(callback)
	return self
	
func onHover(callback: Callable) -> ButtonBuilder:
	_content_node.mouse_entered.connect(callback)
	return self

# func background(color: Color) -> ButtonBuilder:
# 	button_style_box.bg_color = color
# 	_content_node.add_theme_stylebox_override("normal", button_style_box)
# 	return self

func cornerRadius(radius: int) -> ButtonBuilder:
	button_style_box.set("corner_radius_top_left", radius)
	button_style_box.set("corner_radius_top_right", radius)
	button_style_box.set("corner_radius_bottom_left", radius)
	button_style_box.set("corner_radius_bottom_right", radius)
	_content_node.add_theme_stylebox_override("normal", button_style_box)
	return self

func disabled(value: bool = true) -> ButtonBuilder:
	_content_node.disabled = value
	return self

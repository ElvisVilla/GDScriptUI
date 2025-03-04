extends RefCounted
class_name ButtonBuilder

var _margin_node: MarginContainer
var button: Button
var button_style_box = StyleBoxFlat.new()

func _init(_text: String):
	_margin_node = MarginContainer.new()
	button = Button.new()
	_margin_node.name = _text + " Button MarginContainer"
	button.name = _text + " Button"
	button.text = _text
	_margin_node.add_child(button)

func in_node(parent: Node) -> ButtonBuilder:
	parent.add_child(_margin_node, true)
	return self

func text(value: String) -> ButtonBuilder:
	button.text = value
	return self

func fontSize(size: int) -> ButtonBuilder:
	button.add_theme_font_size_override("font_size", size)
	return self

func onPressed(callback: Callable) -> ButtonBuilder:
	button.pressed.connect(callback)
	return self
	
func onHover(callback: Callable) -> ButtonBuilder:
	button.mouse_entered.connect(callback)
	return self

func background(color: Color) -> ButtonBuilder:
	button_style_box.bg_color = color
	button.add_theme_stylebox_override("normal", button_style_box)
	return self

func corner_radius(radius: int) -> ButtonBuilder:
	button_style_box.set("corner_radius_top_left", radius)
	button_style_box.set("corner_radius_top_right", radius)
	button_style_box.set("corner_radius_bottom_left", radius)
	button_style_box.set("corner_radius_bottom_right", radius)
	button.add_theme_stylebox_override("normal", button_style_box)
	return self
	
func padding(amount: int) -> ButtonBuilder:
	_margin_node.add_theme_constant_override("margin_left", amount)
	_margin_node.add_theme_constant_override("margin_right", amount)
	_margin_node.add_theme_constant_override("margin_top", amount)
	_margin_node.add_theme_constant_override("margin_bottom", amount)

	return self
	
func visible(value: bool = true) -> ButtonBuilder:
	_margin_node.visible = value
	return self

func disabled(value: bool = true) -> ButtonBuilder:
	button.disabled = value
	return self
	
func tooltip(text: String) -> ButtonBuilder:
	button.tooltip_text = text
	return self

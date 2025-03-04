@tool
extends RefCounted
class_name LabelBuilder

var _margin_node: Label

func _init(text: String = ""):
	_margin_node = Label.new()
	_margin_node.text = text

func in_node(parent: Node) -> LabelBuilder:
	parent.add_child(_margin_node)
	print("Added")
	return self

func text(value: String) -> LabelBuilder:
	_margin_node.text = value
	return self

func fontSize(size: int) -> LabelBuilder:
	_margin_node.add_theme_font_size_override("font_size", size)
	return self

func align(horizontal: int = HORIZONTAL_ALIGNMENT_LEFT, vertical: int = VERTICAL_ALIGNMENT_CENTER) -> LabelBuilder:
	_margin_node.horizontal_alignment = horizontal
	_margin_node.vertical_alignment = vertical
	return self

func autowrap(enable: bool = true) -> LabelBuilder:
	_margin_node.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART if enable else TextServer.AUTOWRAP_OFF
	return self

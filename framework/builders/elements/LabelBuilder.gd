extends BaseBuilder
class_name LabelBuilder

func _init(text: String = ""):
	_content_node = Label.new()
	_content_node.text = text
	_content_node.name = text + "_label"

# func in_node(parent: Node) -> LabelBuilder:
# 	parent.add_child(_margin_node)
# 	print("Added")
# 	return self

func text(value: String) -> LabelBuilder:
	_content_node.text = value
	return self

func fontSize(size: int) -> LabelBuilder:
	_content_node.add_theme_font_size_override("font_size", size)
	return self

func align(horizontal: int = HORIZONTAL_ALIGNMENT_LEFT, vertical: int = VERTICAL_ALIGNMENT_CENTER) -> LabelBuilder:
	_content_node.horizontal_alignment = horizontal
	_content_node.vertical_alignment = vertical
	return self

func autowrap(enable: bool = true) -> LabelBuilder:
	_content_node.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART if enable else TextServer.AUTOWRAP_OFF
	return self

extends BaseBuilder
class_name LabelBuilder

@warning_ignore("shadowed_variable")
func _init(text: String = ""):
	_content_node = Label.new()
	_content_node.text = text
	_content_node.name = text + "_label"
	shrinkHorizontal()

# func in_node(parent: Node) -> LabelBuilder:
# 	parent.add_child(_margin_node)
# 	print("Added")
# 	return self

func text(value: String) -> LabelBuilder:
	_content_node.text = value
	return self

func fontSize(font_size: int) -> LabelBuilder:
	_content_node.add_theme_font_size_override("font_size", font_size)
	_add_explicit_modifier("fontSize", font_size)
	return self

func align(horizontal: View.TextAlignment = View.TextAlignment.LEADING, vertical: View.TextAlignment = View.TextAlignment.CENTER) -> LabelBuilder:
	_content_node.horizontal_alignment = horizontal
	_content_node.vertical_alignment = vertical
	return self

func autowrap(mode: TextServer.AutowrapMode = TextServer.AUTOWRAP_WORD) -> LabelBuilder:
	_content_node.autowrap_mode = mode
	return self

extends RefCounted
class_name TextureRectBuilder

var _margin_node: TextureRect

func _init(texture):
	_margin_node = TextureRect.new()
	# if texture != null:
	_margin_node.texture = load(texture)

func in_node(parent: Node) -> TextureRectBuilder:
	parent.add_child(_margin_node)
	return self

func texture(value) -> TextureRectBuilder:
	_margin_node.texture = value
	return self

## Sets how the texture's minimum size is determined based on its dimensions
## See ExpandMode enum for detailed descriptions of each mode
func expand_mode(mode: View.ExpandMode) -> TextureRectBuilder:
	_margin_node.expand_mode = int(mode)
	return self

# Controls how the texture is displayed within its bounding rectangle
# See StretchMode enum for detailed descriptions of each mode
func stretch_mode(mode: View.StretchMode) -> TextureRectBuilder:
	_margin_node.stretch_mode = int(mode)
	return self

# Sets the custom minimum size of the TextureRect
func size(width: int, height: int) -> TextureRectBuilder:
	_margin_node.custom_minimum_size = Vector2(width, height)
	return self

# Sets the frame/bounds of the TextureRect
# This method allows defining explicit width and height boundaries
# along with additional size flags and anchors if needed
func frame(width: int, height: int, expand: bool = true) -> TextureRectBuilder:
	_margin_node.custom_minimum_size = Vector2(width, height)
	
	if expand:
		_margin_node.size_flags_horizontal = Control.SIZE_FILL
		_margin_node.size_flags_vertical = Control.SIZE_FILL
	
	return self

# Flips the texture horizontally
func flip_h(enable: bool = true) -> TextureRectBuilder:
	_margin_node.flip_h = enable
	return self

# Flips the texture vertically
func flip_v(enable: bool = true) -> TextureRectBuilder:
	_margin_node.flip_v = enable
	return self

func visible(enable: bool = true) -> TextureRectBuilder:
	_margin_node.visible = enable
	return self

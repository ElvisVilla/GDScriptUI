extends BaseBuilder
class_name TextureRectBuilder

func _init(image_name: String = ""):
	_content_node = TextureRect.new()
	_content_node.texture = load(image_name)

#TODO: Make API image sizing more close to SwiftUI sizing

## Sets how the texture's minimum size is determined based on its dimensions
## See ExpandMode enum for detailed descriptions of each mode
func expandMode(mode: View.ExpandMode) -> TextureRectBuilder:
	_content_node.expand_mode = mode
	return self

## Controls how the texture is displayed within its bounding rectangle
## See StretchMode enum for detailed descriptions of each mode
func stretchMode(mode: View.StretchMode) -> TextureRectBuilder:
	_content_node.stretch_mode = mode
	return self

## Ignore original Texture size
func resize():
	_content_node.expand_mode = View.ExpandMode.IGNORE_SIZE
	return self

# Flips the texture horizontally
func flipHorizontal(enable: bool = true) -> TextureRectBuilder:
	_content_node.flipHorizontal = enable
	return self

# Flips the texture vertically
func flipVertical(enable: bool = true) -> TextureRectBuilder:
	_content_node.flipVertical = enable
	return self

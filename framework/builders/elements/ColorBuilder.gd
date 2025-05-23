extends BaseBuilder
class_name ColorBuilder

func _init(color) -> void:
	_content_node = Panel.new()
	_content_node.name = "Color"


	if color is GradientTexture2D:
		var style = StyleBoxTexture.new()
		style.texture = color
		_content_node.add_theme_stylebox_override("panel", style)
	else:
		# Solid color option
		var style = StyleBoxFlat.new()
		style.bg_color = color
		_content_node.add_theme_stylebox_override("panel", style)


	_content_node.size_flags_horizontal = View.SizeFlags.FILL
	_content_node.size_flags_vertical = View.SizeFlags.FILL

#TODO: Clip with shape to have allow Corner Radius on Gradients
func cornerRadius(radius: int) -> ColorBuilder:
	var style = _content_node.get_theme_stylebox("panel")
	if style is StyleBoxFlat: # Only works for Color Flat
		style.corner_radius_top_left = radius
		style.corner_radius_top_right = radius
		style.corner_radius_bottom_left = radius
		style.corner_radius_bottom_right = radius
	return self

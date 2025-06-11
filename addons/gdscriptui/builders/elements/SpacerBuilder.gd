extends BaseBuilder
class_name SpacerBuilder

func _init():
    _content_node = Control.new()
    _content_node.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    _content_node.size_flags_vertical = Control.SIZE_EXPAND_FILL

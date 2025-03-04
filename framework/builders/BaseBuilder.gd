extends RefCounted
class_name BaseBuilder

var _content_node: Control # The actual control being built (Button, Label, etc.)
var _margin_node: MarginContainer # Optional margin wrapper
var _use_margin: bool = false # Flag to determine if we're using margin

func _init():
    pass
    
# Creates and configures the margin container if needed
func _setup_margin_if_needed():
    if _use_margin and not _margin_node:
        _margin_node = MarginContainer.new()
        if _content_node.get_parent():
            var parent = _content_node.get_parent()
            parent.remove_child(_content_node)
            parent.add_child(_margin_node)
            _margin_node.add_child(_content_node)
        else:
            _margin_node.add_child(_content_node)

## Gets the node that should be added to the parent
func _get_parent_node() -> Control:
    return _margin_node if _use_margin else _content_node

# Toggle margin container usage
func _with_margin(enable: bool = true) -> BaseBuilder:
    _use_margin = enable
    _setup_margin_if_needed()
    return self

# Add to parent node
func _in_node(parent: Node) -> BaseBuilder:
    parent.add_child(_get_parent_node())
    return self

# Visibility control
func visible(value: bool = true) -> BaseBuilder:
    _get_parent_node().visible = value
    return self

# Size control
func size(width: int, height: int) -> BaseBuilder:
    _content_node.custom_minimum_size = Vector2(width, height)
    return self

# Name setting (applies to both the main node and the margin if present)
func name(value: String) -> BaseBuilder:
    _content_node.name = value
    if _use_margin and _margin_node:
        _margin_node.name = value + " Container"
    return self

# Focus control
func focusable(value: bool = true) -> BaseBuilder:
    _content_node.focus_mode = Control.FOCUS_ALL if value else Control.FOCUS_NONE
    return self

# Tooltip
func tooltip(text: String) -> BaseBuilder:
    _content_node.tooltip_text = text
    return self

# Mouse filter
func mouse_filter(filter: Control.MouseFilter) -> BaseBuilder:
    _content_node.mouse_filter = filter
    return self

# Padding - only works if margins are enabled
func padding(amount: int = 8) -> BaseBuilder:
    if not _use_margin:
        # Automatically enable margin if padding is requested
        _with_margin(true)
    
    _margin_node.add_theme_constant_override("margin_left", amount)
    _margin_node.add_theme_constant_override("margin_right", amount)
    _margin_node.add_theme_constant_override("margin_top", amount)
    _margin_node.add_theme_constant_override("margin_bottom", amount)
    return self
    
# Set specific padding values
func padding_specific(left: int = 0, top: int = 0, right: int = 0, bottom: int = 0) -> BaseBuilder:
    if not _use_margin:
        # Automatically enable margin if padding is requested
        _with_margin(true)
    
    _margin_node.add_theme_constant_override("margin_left", left)
    _margin_node.add_theme_constant_override("margin_top", top)
    _margin_node.add_theme_constant_override("margin_right", right)
    _margin_node.add_theme_constant_override("margin_bottom", bottom)
    return self


func frame(width: int = -1, height: int = -1, expand_h: bool = false,
        expand_v: bool = false, fill_ratio: float = 1.0) -> BaseBuilder:
    if width >= 0 and height >= 0:
        _content_node.custom_minimum_size = Vector2(width, height)
    
    if expand_h:
        _content_node.size_flags_horizontal = Control.SIZE_FILL
        if fill_ratio != 1.0:
            _content_node.size_flags_stretch_ratio = fill_ratio
    
    if expand_v:
        _content_node.size_flags_vertical = Control.SIZE_FILL
    
    return self

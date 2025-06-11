extends PanelContainer
class_name Modal

var is_presented: Binding
var view_content: BaseBuilder
var animation_tween: Tween

var margin_top = 50
var margin_right = 16
var margin_left = 16
var margin_down = 0

@onready var horizontal_margin = margin_right + margin_left
@onready var vertical_margin = margin_top + margin_down

var initial_position_offscreen_horizontal: Vector2
var initial_position_off_screen_Vertical: Vector2
var position_in_screen := Vector2(16, 80)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index = 1
	var viewport_size = get_viewport().size
	size = Vector2(viewport_size.x - horizontal_margin, viewport_size.y - vertical_margin)
	initial_position_offscreen_horizontal = Vector2(size.x, 0)
	initial_position_off_screen_Vertical = Vector2(16, size.y + 80)
	set_slide_vertical()
	
	
func set_slide_vertical():
	var viewport_size = get_viewport().size
	size = Vector2(viewport_size.x - horizontal_margin, viewport_size.y - vertical_margin)
	position = initial_position_off_screen_Vertical
	
func set_slide_horizontal():
	size = Vector2(720, 1280)
	initial_position_offscreen_horizontal = Vector2(size.x, 0)
	position = Vector2(size.x, 0)


# func _init(isPresented: Binding, view_content: BaseBuilder) -> void:
# 	is_presented = isPresented
# 	view_content = view_content

# 	is_presented.bind(self, "isPresented", func(new_value):
# 		if new_value:
# 			present()
# 		else:
# 			dismiss()
# 	)

func present():
	# Implement custom behaviour in subclasses
	pass

func dismiss():
	# is_presented.value = false
	# Implement custom behaviour in subclasses
	pass
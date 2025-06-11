extends Modal
class_name Sheet

func present():
	# Animate in from bottom
	var view_instance = instance_from_id(view_content.get_instance_id())
	print_debug(view_instance)
	view_content._in_node(self)
	position = initial_position_off_screen_Vertical
	show()
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", position_in_screen, 0.5)

func dismiss():
	# Animate out to bottom
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", initial_position_off_screen_Vertical, 0.5)
	await tween.finished
	# var child = get_child(0)
	# remove_child(child)
	# hide()
	self.queue_free()

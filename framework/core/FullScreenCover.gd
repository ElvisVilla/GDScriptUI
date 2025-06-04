extends Modal
class_name FullScreenCover


func present():
    show()
    # Fade in
    var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
    tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.3)

func dismiss():
    # Fade out
    var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
    tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.3)
    await tween.finished
    hide()

extends RefCounted
class_name Flow
#This class helps us to define characteristics of the animation

signal OnAnimationStart
signal OnAnimationFinish

# Animation timing functions (easing)
enum Easing {
	LINEAR = Tween.EASE_IN_OUT,
	EASE_IN = Tween.EASE_IN,
	EASE_OUT = Tween.EASE_OUT,
	EASE_IN_OUT = Tween.EASE_IN_OUT
}

# Animation curve types
enum CurveType {
	LINEAR = Tween.TRANS_LINEAR,
	SINE = Tween.TRANS_SINE,
	QUAD = Tween.TRANS_QUAD,
	CUBIC = Tween.TRANS_CUBIC,
	QUART = Tween.TRANS_QUART,
	QUINT = Tween.TRANS_QUINT,
	EXPO = Tween.TRANS_EXPO,
	ELASTIC = Tween.TRANS_ELASTIC,
	BOUNCE = Tween.TRANS_BOUNCE,
	BACK = Tween.TRANS_BACK,
	SPRING = Tween.TRANS_SPRING,
}

# Default animation duration in seconds
var _duration: float = 0.3
# Default animation delay in seconds
var _delay: float = 0.0
# Default easing function
var _easing: Easing = Easing.EASE_OUT
# Default curve type
var _curve: CurveType = CurveType.CUBIC
# Whether the animation should repeat
var _repeat: bool = false
# Number of times to repeat (-1 for infinite)
var _repeat_count: int = 0
# Whether the animation should play in reverse when repeating
var _yoyo: bool = false

# Add a new property to store the current tween
var _current_tween: Tween = null

# Create a new animation with default settings
static func default() -> Flow:
	return Flow.new()

## Use decimals for float, integer values will not interpolate
static func duration(seconds: float) -> Flow:
	var flow = Flow.new()
	flow._duration = float(seconds)
	return flow

# Set the animation delay
func delay(seconds: float) -> Flow:
	_delay = seconds
	return self

# Set the easing function
func ease(type: Easing) -> Flow:
	_easing = type
	return self

# Set the curve type
func curve(type: CurveType) -> Flow:
	_curve = type
	return self

# Enable/disable animation repetition
func repeat(should_repeat: bool = true) -> Flow:
	_repeat = should_repeat
	return self

# Set the number of times to repeat
func repeat_count(count: int) -> Flow:
	_repeat_count = count
	return self

# Enable/disable yoyo effect (reverse animation when repeating)
func yoyo(should_yoyo: bool = true) -> Flow:
	_yoyo = should_yoyo
	return self

# Apply the animation to a property
# this should go inside of BaseBuilder, but what we really want is
# we have the dictionary of the Binding that is conected to all those modifiers
# we know exactly what are those modifiers changing so we can animate those in parallele
# this code serve as a good example of what we want to do in terms of logic

# func animate(object: Object, property: String, from_value: Variant, to_value: Variant) -> Tween:
# 	var tween = object.create_tween()
# 	tween.set_ease(_easing)
# 	tween.set_trans(_curve)
	
# 	if repeat:
# 		tween.set_loops(repeat_count)
	
# 	if yoyo:
# 		tween.set_parallel(false)
# 		tween.tween_property(object, property, to_value, duration)
# 		tween.tween_property(object, property, from_value, duration)
# 	else:
# 		tween.tween_property(object, property, to_value, duration)
	
# 	if _delay > 0:
# 		tween.set_delay(delay)
	
# 	return tween

# Apply the animation to multiple properties in parallel
# func animate_parallel(object: Object, properties: Dictionary) -> Tween:
# 	var tween = object.create_tween()
# 	tween.set_ease(_easing)
# 	tween.set_trans(curve)
# 	tween.set_parallel(true)
	
# 	if repeat:
# 		tween.set_loops(repeat_count)
	
# 	for property in properties:
# 		var from_value = properties[property]["from"]
# 		var to_value = properties[property]["to"]
		
# 		if yoyo:
# 			tween.tween_property(object, property, to_value, duration)
# 			tween.tween_property(object, property, from_value, duration)
# 		else:
# 			tween.tween_property(object, property, to_value, duration)
	
# 	if _delay > 0:
# 		tween.set_delay(delay)
	
# 	return tween

# Add a method to interpolate between two values
func interpolate(from_value: Variant, to_value: Variant, callback: Callable) -> void:
	OnAnimationStart.emit()
	# Kill any existing tween
	if _current_tween != null:
		_current_tween.kill()

	# Create new tween
	_current_tween = Engine.get_main_loop().root.create_tween()
	_current_tween.set_ease(int(_easing))
	# _current_tween.set_ease(Tween.EASE_IN_OUT)
	_current_tween.set_trans(int(_curve))
	# _current_tween.set_trans(Tween.TRANS_CUBIC)

	if _repeat:
		_current_tween.set_loops(_repeat_count)

	# Set up the interpolation
	_current_tween.tween_method(func(current_value: float):
		callback.call(current_value)
		,
		from_value,
		to_value,
		_duration
	)

	_current_tween.finished.connect(func():
		OnAnimationFinish.emit())


	# if _delay > 0:
	# 	_current_tween.set_delay(_delay)
	
	# if _yoyo:
	# 	_current_tween.set_parallel(false)
	# 	_current_tween.tween_method(func(delta: float):
	# 		callback.call(delta)
	# 		,
	# 		_duration,
	# 		0.0,
	# 		_duration
	# 	)

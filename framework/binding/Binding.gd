extends RefCounted
class_name Binding

signal OnAnimationStart
signal OnAnimationFinish

var flow: Flow
var _old_value
var skipped_at_start = false

var value:
	set(new_value):
		if not skipped_at_start:
			skipped_at_start = true
			value = new_value
			return
			
		_old_value = value
		value = new_value

		if flow:
			flow.interpolate(_old_value, new_value, func(interpolate_value):
				_notify_binds(interpolate_value))
		else:
			_notify_binds(value)
	get:
		return value

var _binds = {} # {node_unique_id: {property_name: Callable}}


func _init(initial_value) -> void:
	value = initial_value

func bind(node: Node, property_name: String, update_callback: Callable):
	var unique_id = node.get_instance_id()
	# if node not exist
	if not _binds.has(unique_id):
		_binds.set(unique_id, {})
	

	_binds[unique_id].set(property_name, update_callback)

	#Initial Update
	update_callback.call(value)

func unbind(node: Control, property_name: String):
	var unique_id = node.get_instance_id()
	if _binds.has(unique_id):
		_binds[unique_id].erase(property_name)
		if _binds[unique_id].is_empty():
			_binds.erase(unique_id)

# This function is called when value change 
func _notify_binds(with_value):
	for node_binds in _binds.values():
		for update_callback in node_binds.values():
			update_callback.call(with_value)


func animation(flow: Flow) -> Binding:
	self.flow = flow
	return self

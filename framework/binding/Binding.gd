extends RefCounted
class_name Binding

var value:
	set(new_value):
		value = new_value
		_notify_binds()
	get:
		return value

var _binds = {} # {node_unique_id: {property_name: Callable}}


func _init(initial_value) -> void:
	value = initial_value

func bind(node: Node, property_name: String, update_callback: Callable):
	var unique_id = node.get_instance_id()
	print_debug("Bind Element Unique ID is: ", unique_id)
	if not _binds.has(unique_id):
		_binds.set(unique_id, {})
	
	_binds[unique_id].set(property_name, update_callback)

	#Initial Update
	update_callback.call(value)

func unbind(node: Control, property_name: String):
	var unique_id = node.get_instance_id()
	print_debug("Unbind Element Unique ID is: ", unique_id)
	if _binds.has(unique_id):
		_binds[unique_id].erase(property_name)
		if _binds[unique_id].is_empty():
			_binds.erase(unique_id)

func _notify_binds():
	for node_binds in _binds.values():
		for update_callback in node_binds.values():
			update_callback.call(value)

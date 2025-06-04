extends RefCounted
class_name ObserveArray

signal collection_changed

var _array: Array
var _binds: Dictionary = {} # {node_unique_id: {property_name: Callable}}

func _init(initial_array: Array = []):
	_array = []

	for item in initial_array:
		_validate_item(item)
		_array.append(item)

func _validate_item(item) -> void:
	if item is Binding:
		push_error("ObserveArray: Cannot store Binding type, instead create bindings at View Level or at Model Objects")
		assert(false, "ObserveArray: Binding objects are not allowed in ObserveArray")

# Binding management
func bind(node: Node, property_name: String, update_callback: Callable) -> void:
	var unique_id = node.get_instance_id()
	if not _binds.has(unique_id):
		_binds[unique_id] = {}
	_binds[unique_id][property_name] = update_callback
	# Initial update
	update_callback.call(_array)

func unbind(node: Node, property_name: String) -> void:
	var unique_id = node.get_instance_id()
	if _binds.has(unique_id):
		_binds[unique_id].erase(property_name)
		if _binds[unique_id].is_empty():
			_binds.erase(unique_id)

# Array operations
func append(item) -> void:
	_validate_item(item)
	_array.append(item)
	_notify_binds()

func insert(index: int, item) -> void:
	_validate_item(item)
	_array.insert(index, item)
	_notify_binds()

func erase(item) -> void:
	_array.erase(item)
	_notify_binds()

func remove_at(index: int) -> void:
	_array.remove_at(index)
	_notify_binds()

func remove_last() -> void:
	_array.remove_at(_array.size() - 1)
	_notify_binds()

func clear() -> void:
	_array.clear()
	_notify_binds()

func find(item) -> int:
	return _array.find(item)

func size() -> int:
	return _array.size()

func length() -> int:
	return _array.size()

func at(index: int):
	return _array[index]

func set_at(index: int, item) -> void:
	_validate_item(item)
	_array[index] = item
	_notify_binds()

func map(func_ref: Callable) -> Array:
	return _array.map(func_ref)

func filter(func_ref: Callable) -> Array:
	return _array.filter(func_ref)

func sort_custom(func_ref: Callable) -> void:
	_array.sort_custom(func_ref)
	_notify_binds()

func duplicate() -> Array:
	return _array.duplicate()

func to_array() -> Array:
	return _array

# Notify all bound nodes
func _notify_binds() -> void:
	for node_binds in _binds.values():
		for update_callback in node_binds.values():
			update_callback.call(_array)

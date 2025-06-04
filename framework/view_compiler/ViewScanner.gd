extends RefCounted
class_name ViewScanner

# var obtained_views = []
var views = []
var views_info: Array[Dictionary] = []

func scan_for_views() -> Array[Dictionary]:
	views = ProjectSettings.get_global_class_list().filter(func(element): return element.base == &"View")

	for view in views:
		views_info.append({
			"base_type": view.base,
			"type": view.class ,
			"constructor": get_constructor(view.path),
			"path": view.path
		})

	return views_info

func get_constructor(path: String):
	var view = load(path).new()
	var methods = view.get_method_list()
	for method in methods:
		if method.name == "configure" and method.flags == METHOD_FLAG_NORMAL:
			return method

	return null

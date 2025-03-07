extends RefCounted
class_name ViewScanner

# var obtained_views = []
var views_info: Array[Dictionary] = []

func scan_for_views(root_path: String) -> Array[Dictionary]:
	print("Scanning for views in: " + root_path)
	var dir = DirAccess.open(root_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".gd"):
				var script_path = root_path + file_name
				var script = load(script_path).new() # Most do load(script_path).new() but this requires to specify parameters
				if script is View:
					views_info.append({
						"file_name": file_name,
						"script_path": script_path,
						"constructor": get_constructor(script)
					})
					# obtained_views.append(script)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

	return views_info


func get_constructor(view: View):
	var methods = view.get_method_list()
	for method in methods:
		if method.name == "configure" and method.flags == METHOD_FLAG_NORMAL:
			return method

# func get_constructors():
# 	var constructors = []
# 	for view in obtained_views:
# 		var methods = view.get_method_list()
# 		for method in methods:
# 			if method.name == "configure" and method.flags == METHOD_FLAG_NORMAL:
# 				constructors.append(method)

# 	return constructors

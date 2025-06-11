extends RefCounted
class_name ViewCompiler

var view_scanner: ViewScanner
var code_generator: ViewCodeGenerator
const view_script_path: String = "res://addons/gdscriptui/core/View.gd"
var views_info = []

func _init() -> void:
	view_scanner = ViewScanner.new() # preload("res://addons/gdscriptui/view_compiler/ViewScanner.gd").new()
	code_generator = ViewCodeGenerator.new()

	#refresh_views()


func refresh_views() -> void:
	var obtained_views = view_scanner.scan_for_views()
	var view_parser = ViewParser.new()

	views_info.clear()
	
	#print_debug(obtained_views.size())
	for view in obtained_views:
		var type = view.type
		var path = view.path
		var parsed_constructor = ""
		if view.constructor != null:
			parsed_constructor = view_parser.parse_view(view.constructor)
		else:
			parsed_constructor = ""

		views_info.append({
			"type": type,
			"path": path,
			"parsed_constructor": parsed_constructor
		})
	
	print("\nview found: ", views_info)

	code_generator.write_code(views_info, view_script_path)
	#print("View registry refreshed - found %d views" % views_info.size())

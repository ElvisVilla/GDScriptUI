extends Node
class_name ViewRegistry

var view_scanner: ViewScanner
var code_generator: ViewCodeGenerator
const root_path: String = "res://framework/views/"
const view_script_path: String = "res://framework/core/View.gd"
var parsed_constructors: Array[String] = []
var views_info = []

func _ready() -> void:
	view_scanner = ViewScanner.new()
	code_generator = ViewCodeGenerator.new()

	refresh_views()


func refresh_views() -> void:
	# view_scanner.scan_for_views(root_path)
	var obtained_views = view_scanner.scan_for_views(root_path)
	var view_parser = ViewParser.new()

	views_info.clear()

	
	for view in obtained_views:
		#configure(total_params)
		var file_name = view.file_name
		var script_path = view.script_path
		var parsed_constructor = ""
		if view.constructor != null:
			parsed_constructor = view_parser.parse_view(view.constructor)
		else:
			parsed_constructor = ""

		views_info.append({
			"file_name": file_name,
			"script_path": script_path,
			"parsed_constructor": parsed_constructor
		})

	code_generator.write_code(views_info, view_script_path)
	print("View registry refreshed - found %d views" % views_info.size())

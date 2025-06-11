@tool
extends EditorPlugin

const ViewCompiler_file = preload("res://addons/gdscriptui/view_compiler/ViewCompiler.gd")
var viewCompiler: ViewCompiler
var count: int = 0
var isRefreshing := false


func _enter_tree():
	print_debug("Entered Tree From Plugin!")
	if viewCompiler == null:
		viewCompiler = ViewCompiler_file.new()
	

	get_editor_interface().get_resource_filesystem().filesystem_changed.connect(_on_filesystem_changed)


func _exit_tree() -> void:
	get_editor_interface().get_resource_filesystem().filesystem_changed.disconnect(_on_filesystem_changed)

	
func _on_filesystem_changed():
	viewCompiler.refresh_views()

extends RefCounted
class_name ViewCodeGenerator

# Markers to identify generated code section
const BEGIN_MARKER = "# BEGIN GENERATED VIEW FUNCTIONS"
const END_MARKER = "# END GENERATED VIEW FUNCTIONS"

var function_template: String = """
func %s:
\tvar element = load("%s").new()
\telement.%s #constructor call
\treturn build_nested_view("%s", element, self)
""" # % parse_func_call, file_path, configure_method


var function_template_without_constructor: String = """
func %s:
\tvar element = load("%s").new()
\treturn build_nested_view("%s", element, self)
"""

var generated_functions = {}


func write_code(user_defined_views, view_script_path: String) -> void:
    if user_defined_views.is_empty():
        print("No views to generate, no user defined views found")
        return


    var file = FileAccess.open(view_script_path, FileAccess.READ)
    if not file:
        push_error("View Script on path: %s not found" % view_script_path)
        return

    var source_code = file.get_as_text()
    file.close()

    var begin_marker_index = source_code.find(BEGIN_MARKER)
    var end_marker_index = source_code.find(END_MARKER)

    if begin_marker_index == -1 or end_marker_index == -1:
        source_code += "\n\n" + BEGIN_MARKER + "\n" + END_MARKER + "\n"
        # push_error("View Script on path: %s does not contain the markers %s and %s" % [view_script_path, BEGIN_MARKER, END_MARKER])
        # return
    elif begin_marker_index == -1 or end_marker_index == -1 or end_marker_index <= begin_marker_index:
        push_error("View Script has malformed markers - fixing it")
        source_code = source_code.replace(BEGIN_MARKER, "").replace(END_MARKER, "")
        source_code += "\n\n" + BEGIN_MARKER + "\n" + END_MARKER + "\n"

    #refresh markers positions
    begin_marker_index = source_code.find(BEGIN_MARKER)
    end_marker_index = source_code.find(END_MARKER)

    var before_marker_code = source_code.substr(0, begin_marker_index + BEGIN_MARKER.length())
    var after_marker_code = source_code.substr(end_marker_index)

    var new_functions = {}
    var appended_code = "\n"

    for view in user_defined_views:
        #Validate required fields
        if not view.has("file_name") or not view.has("script_path") or not view.has("parsed_constructor"):
            push_error("Invalid view definition: %s" % view)
            continue

        var file_name = view["file_name"]
        var script_path = view["script_path"]
        var parsed_constructor = view["parsed_constructor"]
        var has_constructor = parsed_constructor != ""
            
        var function_code = ""

        if has_constructor:
            var function_name = file_name.replace(".gd", "")
            var view_function_name = parsed_constructor.replace("configure", function_name.replace(" ", ""))
            function_code = function_template % [view_function_name, script_path, parsed_constructor, function_name]
        else:
            var function_name = file_name.replace(".gd", "")
            var view_function_name = function_name.replace(" ", "") + "()"
            function_code = function_template_without_constructor % [view_function_name, script_path, function_name]

        new_functions[parsed_constructor] = function_code

        #Add each function to the appended code
        appended_code += function_code + "\n"

    var new_source_code = before_marker_code + appended_code + after_marker_code

    if new_source_code == source_code:
        print("No changes to View Script on path: %s" % view_script_path)
        return

    file = FileAccess.open(view_script_path, FileAccess.WRITE)
    if not file:
        push_error("Failed to open View Script on path: %s for writing" % view_script_path)
        return

    file.store_string(new_source_code)
    file.close()

    generated_functions = new_functions
    print("Updated View Script on path: %s updated with %d new functions" % [view_script_path, new_functions.size()])

    ResourceLoader.remove_resource_format_loader(null)

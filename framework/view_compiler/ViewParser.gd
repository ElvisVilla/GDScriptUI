extends RefCounted
class_name ViewParser


func parse_view(constructor) -> String:
	#is an array with dictionaries, first element is name and represent the parameter name, the second is args and is the arguments of the method
	var func_call: String = "configure("
	var func_call_args: String = ""

	#args is an array of dictionaries, name is the name of the parameter 
	var count = 0
	while count < constructor.args.size():
		#only add ',' if its the last parameter 
		func_call_args += constructor.args[count].get("name")


		if count < constructor.args.size() - 1:
			func_call_args += ", "
			
		count += 1

	func_call += func_call_args + ")"


	print(func_call)
	return func_call

# GDScriptUI

GDScriptUI is a declarative UI framework for Godot 4 inspired by SwiftUI.<br>
Bringing an elegant component-based approach to GDScript. It aims to create modular interfaces with a clean, functional syntax<br>
without the verbosity of traditional scene-based UI development.

## Key Features

- **Function-Based Views**: Build UIs with simple calls like `Button()`, `Image()`,`Label()`, `VBox()`, `HBox()`  and your custom views
- **Auto-Generated Components**: Your View files automatically become available as functions
- **Composable Design**: Nest and combine components with a clean, readable syntax
- **Live Updates**: UI components refresh when you add or modify view files

## Example

```gdscript
extends View
class_name PersonView

var names: Array = ["Lucy", "Albert", "Niklas", "John", "Mariela"]

#Observed property
var person_name: String:
	set(value):
		person_name = value
		observe("person_name", person_name)

func _init(named: String) -> void:
	person_name = named

func _ready() -> void:
	body = [
		HBox("Person container", [
			
			Label(person_name)
				.fontSize(20),

			Image("res://icon.svg")
				.expand_mode(ExpandMode.IGNORE_SIZE)
				.frame(50, 50),

			Button("Random Name")
				.onPressed(func(): person_name = names.pick_random())
		])
	]

```

## How It Works

GDScriptUI scans your project for View subclasses and dynamically generates factory methods, making your custom components instantly available with the same syntax as built-in elements.

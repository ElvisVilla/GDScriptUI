# GDScriptUI (Status Experimental)

GDScriptUI is a declarative UI framework built on top of Godot Engine UI Nodes.<br>
Inspired on SwiftUI, this framework brings an elegant declarative approach to GDScript.<br> 
It aims to create modular interfaces with a clean, functional syntax without managing Control Nodes directly from the Scene Tree.

### 🎨 Declarative Syntax
Write your UI layouts in a clean, declarative way:

```gdscript
body = [
    VBox([
        Label("Hello World")
            .fontSize(78),
        Button("Click Me")
            .onPressed(func(): print("Clicked!"))
    ])
    .spacing(10)
    .background(Color.BLACK.lightened(0.2), 10)
]
```

### 📦 Built-in Components
- **Current Implemented Containers**
  - `HBox` - Horizontal container
  - `VBox` - Vertical container
  - `ForEach` - Dynamic list rendering

- **Current Implemented Elements**
  - `Label` - Text display with auto-wrapping and alignment
  - `Button` - Customizable buttons with events
  - `Image` - Texture display with various sizing options
  - `TextEdit` - Text input fields
  - `Spacer` - Push View
 
- **On the Roadmap** 
  - `Grid`
  - `ScrollContainer`
  - `LineEdit`
  - `OptionButton`
  - `ItemList`
  - `Slider`
  - `TabButtons`

## Usage Example

```gdscript
extends View
class_name SimpleView

var items = ["Sword", "Shield", "Potion"]

func _ready():
	body = [
		#VBox is center aligned by default
		VBox([
			Label("Inventory")
				.fontSize(78),
			
			ForEach(items, func(item):
				return Label(item).align(TextAlignment.CENTER))
			.vertical() # makes the labels stack vertically
		])
		.spacing(10)
		.background(Color.BLACK.lightened(0.2), 10)
	]
```

<img width="562" alt="Screenshot 2025-03-27 at 12 23 26" src="https://github.com/user-attachments/assets/0f142693-eddd-42ef-8d9a-d30184267c3c" />


## Reusable Custom Views

GDScriptUI scans your project for View subclasses and dynamically generates factory methods, making your custom components instantly available with the same syntax as built-in elements.

```gdscript
extends View
class_name ContentView


func _ready():
	#Body is where all the UI elements are defined
	body = [
		VBox([
			Label("Hello World"),
			Button("Click me"),

			SimpleView()
		])
	]
```

<img width="562" alt="Screenshot 2025-03-27 at 13 15 17" src="https://github.com/user-attachments/assets/8e5a7a0e-61d6-4bb9-9193-f7436d46d467" />

## Reactive Properties

The framework supports reactive properties that automatically trigger UI updates:

```gdscript
extends View
class_name PersonView

var names: Array = ["Lucy", "Albert", "Niklas", "John", "Mariela"]

#Observed property
var person_name: String = "Lucy":
	set(value):
		person_name = value
		observe("person_name", person_name)

func _ready() -> void:
	body = [
		HBox([
			
			Label(person_name)
				.fontSize(20), # ',' defines the end of the component

			Image("res://icon.svg")
				.expand_mode(ExpandMode.IGNORE_SIZE)
				.frame(50, 50) #We can define our own size
				.visible(person_name == "Lucy"),

			Button("Random Name")
				.onPressed(func(): person_name = names.pick_random())
		])
		.spacing(5)
	]
```

https://github.com/user-attachments/assets/c4614358-0c6e-46cb-b281-4589782293ea

## Key Features

- **Function-Based Views**: Build UIs with simple calls like `Button()`, `Image()`,`Label()`, `VBox()`, `HBox()`  and your custom views
- **Reusable Custom Views**: Your View files automatically become available as custom views `SimpleView()`, `PersonView()`
- **Composable Design**: Nest and combine views with a clean, readable syntax
- **Reactive Updates**: UI automatically rebuilds when observable properties change (Subject to change)
- **Flexible Layouts**: Powerful layout system with spacing, alignment, and padding
- **Style Customization**: Easy styling with methods like `.background()`, `.fontSize()`, `.cornerRadius()`
- **Modifier Propagation**: Containers propagate style modifiers to childs `.fontSize()`
- **Event Handling**: Simple callback system for user interactions `Button("Delete").onPress(deleteItem)`, `Label("Delete").onTap(deleteItem)`
- **Responsive Design**: Support for flexible and fixed sizing with `Infinity` and `FitContent` constants
- **Label FitContent**: Label support FitContent and wrapping by default


### 🛠 Layout Modifiers
Common modifiers available for components:
- `.frame()` - Set component dimensions FitContent or Infinity for expansion
- `.padding()` - Add padding around components
- `.background()` - Set background color and corner radius
- `.spacing()` - Control space between items in containers
- `.alignment()` - Control alignment of items BoxContainerAlignment.CENTER by default, other options (.BEGGIN, END)
- `.visible(value)` - Toggle visibility

## Architecture

- **View**: Super class for all UI views
- **Builders**: Component builders that handle the creation and modification of UI elements
- **UIRoot**: Manages the UI tree and handles property changes

## Standard Setup

- Instantiate UIRoot in your level or in your CanvasLayer:
  This is a node that extends from panel container. Adapt its size as you need.

- Make a script that inherits from View.
  Define your UI inside of the Body

- Add your View as a child of UIRoot and add a reference to the inspector (This might change in the future)


## Requirements

- Godot 4.x
- GDScript

## License
This project is licensed under the [MIT License](LICENSE).

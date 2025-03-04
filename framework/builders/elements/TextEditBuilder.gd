extends BaseBuilder
class_name TextEditBuilder

func _init(initial_text: String = "", place_holder: String = ""):
	_content_node = TextEdit.new()
	_content_node.name = "Text Edit"
	_content_node.text = initial_text
	_content_node.placeholder_text = place_holder


# Sets the text content
func text(value: String) -> TextEditBuilder:
	_content_node.text = value
	return self

# Sets whether the text can be edited
func editable(value: bool = true) -> TextEditBuilder:
	_content_node.editable = value
	return self

# Sets the text color
func textColor(color: Color) -> TextEditBuilder:
	_content_node.add_theme_color_override("font_color", color)
	return self

# Sets the background color
func backgroundColor(color: Color) -> TextEditBuilder:
	_content_node.add_theme_color_override("background_color", color)
	return self

# Controls word wrapping
func wordWrap(enabled: bool = true) -> TextEditBuilder:
	_content_node.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY if enabled else TextEdit.LINE_WRAPPING_NONE
	return self

# Controls whether to highlight the current line
func highlightCurrentLine(enabled: bool = true) -> TextEditBuilder:
	_content_node.highlight_current_line = enabled
	return self

# Controls whether to highlight all occurrences of selected text
func highlightAllOccurrences(enabled: bool = true) -> TextEditBuilder:
	_content_node.highlight_all_occurrences = enabled
	return self

# Controls whether line numbers are shown
func showLineNumbers(enabled: bool = true) -> TextEditBuilder:
	_content_node.minimap_draw = enabled
	_content_node.line_folding = enabled
	_content_node.gutters_draw_line_numbers = enabled
	return self

# Controls whether the text is in read-only mode
func readonly(value: bool = true) -> TextEditBuilder:
	_content_node.editable = !value
	return self

# Controls syntax highlighting (set to a specific language)
func syntaxHighlighting(language: String = "") -> TextEditBuilder:
	_content_node.syntax_highlighter = CodeHighlighter.new()
	# This is a simplified approach - in a real implementation
	# you would want to configure the highlighter for the specific language
	return self

# Sets multiple options at once for code editing
func codeEditor(show_line_numbers: bool = true, word_wrap: bool = false,
				syntax_language: String = "") -> TextEditBuilder:
	showLineNumbers(show_line_numbers)
	wordWrap(word_wrap)
	if syntax_language:
		syntaxHighlighting(syntax_language)
	return self

# Connect to text changed event
func onTextChanged(callback: Callable) -> TextEditBuilder:
	_content_node.text_changed.connect(callback)
	return self

# Context menu enabled/disabled
func contextMenu(enabled: bool = true) -> TextEditBuilder:
	_content_node.context_menu_enabled = enabled
	return self

# Set tab size
func tabSize(spaces: int = 4) -> TextEditBuilder:
	_content_node.indent_size = spaces
	return self

func fontSize(font_size: int) -> TextEditBuilder:
	_content_node.add_theme_font_size_override("font_size", font_size)
	return self

# Auto-indent new lines
func autoIndent(enabled: bool = true) -> TextEditBuilder:
	_content_node.auto_indent = enabled
	return self

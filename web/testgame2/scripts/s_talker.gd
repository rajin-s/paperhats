extends Node

export var speech_name = ""
export(String, MULTILINE) var text = ""
export var bubble_path : NodePath
var bubble

var lines = []
var current_line = 0

func _ready():
	lines = text.split("\n")
	lines.append("END")
	if speech_name == "":
		speech_name = null
	
	var interaction = $".."
	interaction.connect("on_interact", self, "say_line")
	interaction.connect("on_ready_interaction", self, "ready_lines")
	interaction.connect("on_leave_interaction", self, "reset_lines")
	bubble = get_node(bubble_path)
	if bubble != null:
		bubble.hide()

func ready_lines():
	if bubble != null:
		bubble.show()

func say_line():
	m_speech.say(lines[current_line], speech_name)
	current_line = (current_line + 1) % len(lines)

func reset_lines():
	current_line = 0
	m_speech.end_speech()
	if bubble != null:
		bubble.hide()
extends Node

export(String, MULTILINE) var text = ""
export var speech_name : String = ""

export var talker_path : NodePath

func _ready():
	var n = get_node(talker_path)
	n.set_text(text)
	if speech_name == "null":
		n.set_speech_name(null)
	else:
		n.set_speech_name(speech_name)
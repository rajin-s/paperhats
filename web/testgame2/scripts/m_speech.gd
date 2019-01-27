extends Node

var timer
var subscribers = []

var current_name
var current_text
var current_length
var current_char
var line_end

signal on_show_speech
signal on_show_char
signal on_finish_line
signal on_end_speech

func register(to_notify, show_speech_function = null, show_char_function = null, finish_line_function = null, end_speech_function = null):
	subscribers.append(to_notify)
	
	if show_char_function != null: connect("on_show_char", to_notify, show_char_function)
	if show_speech_function != null: connect("on_show_speech", to_notify, show_speech_function)
	if end_speech_function != null: connect("on_end_speech", to_notify, end_speech_function)
	if finish_line_function != null: connect("on_finish_line", to_notify, finish_line_function)
	
func register_timer(timer):
	self.timer = timer
	timer.connect("timeout", self, "show_char")
	
func say(text, name = null):
	if text == "END":
		end_speech()
	else:
		current_text = text
		current_name = name
		current_length = len(text)
		current_char = 0
		line_end = false
		show_speech()
	
func show_speech():
	timer.start()
	emit_signal("on_show_speech")

func end_speech():
	timer.stop()
	emit_signal("on_end_speech")
	
func show_char():
	if current_char < current_length - 1:
		current_char += 1
		emit_signal("on_show_char")
	elif not line_end:
		line_end = true
		emit_signal("on_finish_line");
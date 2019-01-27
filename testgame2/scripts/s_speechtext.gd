extends Label

var container
onready var tick_sfx = $"./SFX"
onready var name_box = $"../Nametext/Container"
onready var name_text = $"../Nametext"

func on_text():
	text = m_speech.current_text
	visible_characters = 0
	
	if m_speech.current_name == null:
		name_text.visible = false
	else:
		name_text.visible = true
		name_text.text = m_speech.current_name
		var line_length = name_text.theme.default_font.get_string_size(m_speech.current_name).x
		name_text.margin_right = line_length
		
	container.visible = true

func on_line():
	pass	

func on_end():
	container.visible = false
	
func on_char():
	percent_visible = float(m_speech.current_char + 1) / float(m_speech.current_length)
	tick_sfx.pitch_scale = rand_range(0.8, 1.3)
	tick_sfx.play()

func _ready():
	m_speech.register(self, "on_text", "on_char", "on_line", "on_end")
	container = $".."
	container.visible = false
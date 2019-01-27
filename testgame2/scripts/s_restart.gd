extends Node

export var health_path : NodePath
export var prompt_path : NodePath

func _ready():
	get_node(health_path).get_node("Player/Health").connect("on_die", self, "show_prompt")
	get_node(prompt_path).visible = false

func _process(delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
func show_prompt():
	get_node(prompt_path).visible = true

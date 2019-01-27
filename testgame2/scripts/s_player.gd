extends Node

onready var object : KinematicBody2D = get_parent()
onready var sprite : AnimatedSprite = $"../AnimatedSprite"

export var speed = 100
var input = Vector2(0, 0)

func _process(delta):
	update_input()
	object.move_and_slide(speed * input)
	
	if input.x == 0 && input.y == 0:
		sprite.play("default")
	else:
		sprite.play("run")
		if input.x < 0:
			sprite.flip_h = true
		elif input.x > 0:
			sprite.flip_h = false
		
func update_input():
	var r = Input.is_action_pressed("right")
	var l = Input.is_action_pressed("left")
	var u = Input.is_action_pressed("up")
	var d = Input.is_action_pressed("down")
	
	if r && !l:
		input.x = 1
	elif l && !r:
		input.x = -1
	else:
		input.x = 0

	if u && !d:
		input.y = -1
	elif d && !u:
		input.y = 1
	else:
		input.y = 0
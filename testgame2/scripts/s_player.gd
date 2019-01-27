extends Node

onready var object : KinematicBody2D = get_parent()
onready var sprite : AnimatedSprite = $"../AnimatedSprite"
onready var particles : Particles2D = $"../Particles2D"
onready var particles_attack : Particles2D = $"../Particles2DAttack"
onready var anim : AnimationPlayer = $"../AnimationPlayer"
onready var attack_timer : Timer = $"../AttackTimer"
onready var anim_rotater : Node2D = $"../HandRotater/Hand Anim Rotater"

export var speed = 100
export var drag = 5
export var attack_speed = 200

export var hand_anim_angle : float = 0
var angle_mod = 1

var input = Vector2(0, 0)
var external : Vector2 = Vector2(0, 0)
var can_attack = true

func _ready():
	attack_timer.connect("timeout", self, "attack_ready")
	
func attack_ready():
	can_attack = true
	particles_attack.emitting = false

func add_external(v):
	external += v

func _process(delta):
	anim_rotater.rotation_degrees = hand_anim_angle * angle_mod
	
	var mpos = object.get_global_mouse_position()
	var dir = (mpos - object.global_position).normalized()
	
	if can_attack and Input.is_action_just_pressed("attack"):
		anim.play("PlayerAttackPrep")
	elif can_attack and Input.is_action_just_released("attack"):
		add_external(dir * attack_speed)
		anim.play("PlayerAttack")
		can_attack = false
		attack_timer.start()
		particles_attack.emitting = true
		if dir.x > 0:
			angle_mod = 1
		elif dir.x < 0:
			angle_mod = -1
		
	if dir.x < 0:
		sprite.flip_h = true
	elif dir.x > 0:
		sprite.flip_h = false
	
	update_input()
	var internal = speed * input
	external = external.linear_interpolate(Vector2.ZERO, delta * drag)
	object.move_and_slide(internal + external)
	
	if input.x == 0 && input.y == 0:
		sprite.play("default")
		particles.emitting = false
	else:
		sprite.play("run")
		particles.emitting = true
		
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
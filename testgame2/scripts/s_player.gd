extends Node

onready var object : KinematicBody2D = get_parent()
onready var sprite : AnimatedSprite = $"../AnimatedSprite"
onready var particles = $"../NewParticles"

onready var particles_attack = $"../NewParticlesAttack"
onready var anim : AnimationPlayer = $"../AnimationPlayer"
onready var attack_timer : Timer = $"../AttackTimer"
onready var anim_rotater : Node2D = $"../HandRotater/Hand Anim Rotater"
onready var hand = $"../../Hand"
var hand_anim_angle : float = 0
var angle_mod = 1

onready var health = $"../Health"
onready var damage_sound = $"../DamageSFX"
onready var die_sound = $"../DieSFX"
onready var damage_fx = $"../Blood"

onready var interaction = $"../Interaction Area/Interaction"

export var speed = 100
export var drag = 5
export var attack_speed = 200
export var knockback = 100

var accept_input = true
var input = Vector2(0, 0)
var external : Vector2 = Vector2(0, 0)
var can_attack = true
var attack_prepped = false

onready var attack_sfx : AudioStreamPlayer2D = $"../AttackSFX"
onready var step_sfx : AudioStreamPlayer2D = $"../StepSFX"
onready var step_sfx_timer : Timer = $"../StepSFX/Timer"

func _ready():
	attack_timer.connect("timeout", self, "attack_ready")
	step_sfx_timer.connect("timeout", self, "play_step_sfx")
	health.connect("on_damage", self, "on_damage")
	health.connect("on_die", self, "on_die")
	
func attack_ready():
	can_attack = true
	particles_attack.stop()

func add_external(v):
	external += v

func play_attack_sfx():
	attack_sfx.pitch_scale = rand_range(0.85, 1.1)
	attack_sfx.play()

func play_step_sfx():
	step_sfx.pitch_scale = rand_range(0.9, 1.2)
	step_sfx.play()

func _process(delta):
	anim_rotater.rotation_degrees = hand_anim_angle * angle_mod
	
	var mpos = object.get_global_mouse_position()
	var dir = (mpos - object.global_position).normalized()
	
	if accept_input and can_attack and not attack_prepped and Input.is_action_pressed("attack"):
		anim.play("PlayerAttackPrep", 0.15)
		attack_prepped = true
	elif accept_input and attack_prepped and Input.is_action_just_released("attack"):
		add_external(dir * attack_speed)
		anim.queue("PlayerAttack")
		can_attack = false
		attack_timer.start()
		particles_attack.start()
		attack_prepped = false
	
	update_input()
	var internal = speed * input
	external = external.linear_interpolate(Vector2.ZERO, delta * drag)
	object.move_and_slide(internal + external)
	
	if not health.dead:
		if Input.is_action_just_released("ui_accept"):
			interaction.interact()
		if dir.x < 0:
			angle_mod = -1
			sprite.flip_h = true
		elif dir.x > 0:
			angle_mod = 1
			sprite.flip_h = false
		if input.x == 0 && input.y == 0:
			sprite.play("default")
			particles.stop()
			if not step_sfx_timer.is_stopped():
				step_sfx_timer.stop()
		else:
			sprite.play("run")
			particles.start()
			if step_sfx_timer.is_stopped():
				step_sfx_timer.emit_signal("timeout")
				step_sfx_timer.start()
		
func update_input():
	if not accept_input:
		return
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

func on_damage():
	damage_sound.pitch_scale = rand_range(0.8, 1.2)
	damage_sound.play()
	damage_fx.emit(4)
	if health.last_damage_source != null:
		var kbdir = (object.global_position - health.last_damage_source.global_position).normalized()
		external += kbdir * knockback
	
func on_die():
	damage_sound.pitch_scale = rand_range(0.8, 1.2)
	die_sound.pitch_scale = rand_range(0.8, 1.2)
	damage_sound.play()
	die_sound.play()
	damage_fx.emit(8)
	sprite.play("die")
	angle_mod = 0
	particles.stop()
	if not step_sfx_timer.is_stopped():
		step_sfx_timer.stop()
	speed = 0
	external = input * speed + external
	input = Vector2.ZERO
	accept_input = false
	hand.accept_input = false
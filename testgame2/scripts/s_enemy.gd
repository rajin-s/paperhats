extends Node

export var speed : float = 25
export var accel : float = 25
export var drag : float = 2
export var knockback : float = 100

var internal : Vector2
var external : Vector2

var target = null
var target_dir = Vector2(0, 0)

onready var object : KinematicBody2D = get_parent()
onready var sprite : AnimatedSprite = $"../AnimatedSprite"
onready var health = $"../Health"
onready var damage_sound = $"../DamageSFX"
onready var die_sound = $"../DieSFX"
onready var damage_fx = $"../Blood"
onready var damage_area = $"../Damage Area"
var aggro_area
var track_timer

func _ready():
	health.connect("on_damage", self, "on_damage")
	health.connect("on_die", self, "on_die")
	aggro_area = $"../Aggro"
	aggro_area.connect("body_entered", self, "process_target_enter")
	aggro_area.connect("body_exited", self, "process_target_exit")
	track_timer = $"./Timer"
	track_timer.connect("timeout", self, "track_target")

func process_target_enter(overlap):
	#print(overlap.name)
	if overlap.is_in_group("Player") and target == null:
		target = overlap
		
func process_target_exit(overlap):
	if overlap == target:
		target = null

func on_damage():
	internal = Vector2.ZERO
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
	speed = 0
	external = internal + external
	internal = Vector2.ZERO
	damage_area.monitoring = false

func track_target():
	if target == null:
		target_dir = null
	else:
		target_dir = (target.global_position - object.global_position).normalized()

func move_to_target(delta):
	if target_dir == null:
		internal = Vector2.ZERO
	else:
		internal = internal.linear_interpolate(target_dir * speed, clamp(delta * accel, 0, 1))
		if internal.x < 0:
			sprite.flip_h = true
		elif internal.x > 0:
			sprite.flip_h = false

func _process(delta):
	move_to_target(delta)
	external = external.linear_interpolate(Vector2.ZERO, clamp(delta * drag, 0, 1))

func _physics_process(delta):
	object.move_and_slide(internal + external)
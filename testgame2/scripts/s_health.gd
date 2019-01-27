extends Node

export var max_health : int = 1
export var can_hit_dead = true
onready var current = max_health
var dead = false
var last_damage_source

signal on_damage
signal on_die

func damage(amount = 1, source = null):
	if dead and not can_hit_dead:
		return
	
	current -= amount
	last_damage_source = source
	if current <= 0 and not dead:
		die()
	else:
		emit_signal("on_damage")
		
func die():
	dead = true
	emit_signal("on_die")
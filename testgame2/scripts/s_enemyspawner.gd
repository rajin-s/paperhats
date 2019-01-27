extends Node

export var radius = 400.0
export var ref_path : NodePath
onready var ref = get_node(ref_path).get_node("Player")
var enemy_prefab = preload("res://prefabs/Enemy.tscn")

func spawn_enemy():
	var a = rand_range(0, 2 * PI)
	var p = Vector2(cos(a), sin(a)) * radius + ref.global_position
	var new_enemy = enemy_prefab.instance()
	add_child(new_enemy)
	new_enemy.global_position = p
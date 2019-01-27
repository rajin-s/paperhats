extends Node

export var count : int = 100
export var radius : float = 1000

var option1 : PackedScene = preload("res://prefabs/Cactus1.tscn")
var option2 : PackedScene = preload("res://prefabs/Cactus2.tscn")
var option3 : PackedScene = preload("res://prefabs/Rock1.tscn")
var option4 : PackedScene = preload("res://prefabs/Grass1.tscn")
var option5 : PackedScene = preload("res://prefabs/Grass2.tscn")
var option6 : PackedScene = preload("res://prefabs/Grass3.tscn")
var option7 : PackedScene = preload("res://prefabs/Rock2.tscn")
var option8 : PackedScene = preload("res://prefabs/Grass4.tscn")
var option9 : PackedScene = preload("res://prefabs/Grass5.tscn")
var option10 : PackedScene = preload("res://prefabs/Dirt1.tscn")
var option11 : PackedScene = preload("res://prefabs/Dirt2.tscn")
var option12 : PackedScene = preload("res://prefabs/Dirt3.tscn")
var option13 : PackedScene = preload("res://prefabs/Plant1.tscn")
var option14 : PackedScene = preload("res://prefabs/Plant2.tscn")

var options

func _ready():
	options = [
		option1, option2, option3, option4, option5, 
		option6, option7, option8, option9, option10,
		option11, option12, option13, option14 ]
	
	for i in count:
		var p = Vector2(rand_range(-radius, radius), rand_range(-radius, radius))
		var choice = options[rand_range(0, len(options))]
		var instance : Sprite = choice.instance()
		add_child(instance)
		instance.position = p
		if rand_range(0.0, 1.0) > 0.5:
			instance.flip_h = true
		instance.scale = Vector2.ONE * rand_range(1, 1.2)
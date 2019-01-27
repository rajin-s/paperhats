extends Node2D

export var ref_path : NodePath = @"../Player"
onready var ref = get_node(ref_path)

export var target_path : NodePath = @"../Player/HandRotater"
onready var target : Node2D = get_node(target_path)

export var pos_target_path : NodePath = @"../Player/HandRotater/HandSpot"
onready var pos_target : Node2D = get_node(pos_target_path)

func _process(delta):
	var mpos = get_global_mouse_position()
	var angle = ref.position.angle_to_point(mpos) + PI
	target.rotation = angle
	global_position = pos_target.global_position
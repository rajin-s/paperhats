extends Node2D

export var ref_path : NodePath = @"../Player"
onready var ref = get_node(ref_path)

export var target_path : NodePath = @"../Player/HandRotater"
onready var target : Node2D = get_node(target_path)

export var pos_target_path : NodePath = @"../Player/HandRotater/HandSpot"
onready var pos_target : Node2D = get_node(pos_target_path)

export var dead_zone : float = 20

var accept_input = true

func _process(delta):
	if not accept_input:
		target.rotation = lerp(target.rotation, 0, min(1, delta * 3))
	else:
		var mpos = get_global_mouse_position()
		var dpos = mpos - global_position
		if dpos.length_squared() > dead_zone * dead_zone:
			var angle = ref.position.angle_to_point(mpos) + PI
			target.rotation = angle
	global_position = pos_target.global_position
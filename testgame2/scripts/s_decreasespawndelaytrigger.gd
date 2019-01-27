extends Area2D

export var timer_path : NodePath
export var interval : float = 1

func _ready():
	connect("body_entered", self, "set_interval")

func set_interval(ref):
	if ref.is_in_group("Player"):
		print("hi")
		var t = get_node(timer_path)
		t.stop()
		t.emit_signal("timeout")
		t.wait_time = interval
		t.start()
		self.queue_free()
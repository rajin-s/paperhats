extends Node2D

export var texture : Texture
export var lifetime_range = Vector2(0.5, 1)
export var size_range = Vector2(3, 10)
export var speed_range = Vector2(0, 10)
export var size_over_lifetime : Curve
export var speed_over_lifetime : Curve
export var base_velocity = Vector2(0, -5)

var spawn_timer : Timer

export var max_points = 100
var point_lifetimes = []
var point_lifespans = []
var point_positions = []
var point_initial_sizes = []
var point_initial_velocities = []
var current = 0

func _ready():
	for i in max_points:
		point_lifespans.append(1)
		point_lifetimes.append(1)
		point_positions.append(Vector2.ZERO)
		point_initial_sizes.append(0)
		point_initial_velocities.append(Vector2.ZERO)
	if has_node("Timer"):
		spawn_timer = get_node("Timer")
		spawn_timer.connect("timeout", self, "add_point")

func start():
	if spawn_timer.is_stopped():
		spawn_timer.emit_signal("timeout")
		spawn_timer.start()
	
func stop():
	if !spawn_timer.is_stopped():
		spawn_timer.stop()

func emit(count):
	for i in count:
		add_point()

func add_point():
	point_lifetimes[current] = 0
	point_lifespans[current] = rand_range(lifetime_range.x, lifetime_range.y)
	point_positions[current] = global_position
	point_initial_sizes[current] = rand_range(size_range.x, size_range.y)
	point_initial_velocities[current] = Vector2(rand_range(speed_range.x, speed_range.y) * (1 if rand_range(0.0, 1.0) > 0.5 else -1), rand_range(speed_range.x, speed_range.y) * (1 if rand_range(0.0, 1.0) > 0.5 else -1))
	current = (current + 1) % max_points

func update_points(delta):
	for i in max_points:
		if point_lifetimes[i] >= 1:
			continue
		point_lifetimes[i] += delta / point_lifespans[i]
		var s = speed_over_lifetime.interpolate_baked(point_lifetimes[i])
		point_positions[i] += delta * (point_initial_velocities[i] * s + base_velocity)

func draw_points():
	var draw_rect : Rect2 = Rect2(0,0,0,0)
	for i in max_points:
		if point_lifetimes[i] >= 1:
			continue
		draw_rect.size = Vector2.ONE * point_initial_sizes[i] * size_over_lifetime.interpolate(point_lifetimes[i])
		draw_rect.position = point_positions[i] - draw_rect.size / 2.0
		draw_texture_rect(texture, draw_rect, false)

func _process(delta):
	update_points(delta)
	update()
	
func _draw():
	draw_set_transform_matrix(get_global_transform().inverse())
	draw_points()
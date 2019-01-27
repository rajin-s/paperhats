extends Node

export var track_targets = false

signal on_interact
signal on_ready_interaction
signal on_leave_interaction

var active_targets = []

func _ready():
	if track_targets:
		get_node("..").connect("area_entered", self, "add_interaction_target")
		get_node("..").connect("area_exited", self, "remove_interaction_target")

func add_interaction_target(target):
	if target.has_node("Interaction"):
		var interaction = target.get_node("Interaction")
		active_targets.append(interaction)
		interaction.emit_signal("on_ready_interaction")

func remove_interaction_target(target):
	if target.has_node("Interaction"):
		var interaction = target.get_node("Interaction")
		active_targets.erase(interaction)
		interaction.emit_signal("on_leave_interaction")

func recieve_interaction(source):
	print("%s recieved interaction from %s" % [ name, source.name ])
	emit_signal("on_interact")

func interact():
	for x in active_targets:
		x.recieve_interaction(self)
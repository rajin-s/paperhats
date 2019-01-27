extends Area2D

export var knockback_source_path : NodePath
var knockback_source = null
export var amount : int = 1

export(String) var ignore_group = ""

func _ready():
	connect("body_entered", self, "try_damage")
	if has_node(knockback_source_path):
		knockback_source = get_node(knockback_source_path)
	
func try_damage(target):
	if target.is_in_group(ignore_group):
		return
	if target.has_node("Health"):
		var h = target.get_node("Health")
		h.damage(amount, knockback_source)
		print("Damage %s by %d" % [ h.get_parent().name, amount ])
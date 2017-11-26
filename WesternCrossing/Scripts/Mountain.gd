extends Node2D

const dx = 42
const lastX = 722
const startX = 303

func _ready():
	pass

func _on_Timer_timeout():
	if (is_visible()):
		set_pos(Vector2(get_pos().x+dx,get_pos().y))
		if (get_pos().x>lastX):
			hide()
	else:
		var chance = randf()
		if (chance<0.2):
			set_pos(Vector2(startX,get_pos().y))
			show()
		


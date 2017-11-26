extends Control

func _ready():
	pass

func _on_Shoot_input_event( ev ):
	if (ev.type == InputEvent.MOUSE_BUTTON):
		if (ev.pressed):
			press()
		else:
			release()

func press():
	get_node("Up").hide()
	get_node("Down").show()

func release():
	get_node("Up").show()
	get_node("Down").hide()

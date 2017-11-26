extends Control

func _ready():
	pass

func press():
	get_node("Released").hide()
	get_node("Pressed").show()

func release():
	get_node("Released").show()
	get_node("Pressed").hide()

func _on_Up_input_event( ev ):
	if (ev.type == InputEvent.MOUSE_BUTTON):
		if (ev.pressed):
			press()
		else:
			release()

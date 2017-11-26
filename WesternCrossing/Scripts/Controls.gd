extends Node2D

# extra controls
# wagon seemed inappropriate and world was alreay full of too much stuff

func _ready():
	set_process_input(true)

func _input(event):
	if (event.is_action_pressed("ui_pause")):
		get_parent().get_node("Pause").press()
		get_parent().gamePause()
	elif (event.is_action_released("ui_pause")):
		get_parent().get_node("Pause").release()
	if (event.is_action_pressed("ui_reset")):
		get_parent().get_node("Reset").press()
		get_parent().reset()
		get_tree().set_pause(false)
	elif (event.is_action_released("ui_reset")):
		get_parent().get_node("Reset").release()
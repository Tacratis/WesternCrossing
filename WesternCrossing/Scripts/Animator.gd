extends Node2D

const flashes = 3
var count
# what is the obstalce that needs to flash
var obstacle
# type of animation (0-ox, 1-wheel, 2-snakeDeath, 3-chief greet)
var type
# wagon, to save retyping
var wagon

func _ready():
	wagon = get_node("/root/World/Wagon")

func reset():
	if (obstacle!=null):
		obstacle.hide()
	get_node("On").stop()
	get_node("Off").stop()
	count = 0
	type = 0

func killOx(snakePos, scale):
	# start timer for flashing
	get_node("On").start()
	# move icon to the proper position and show it
	obstacle = get_node("Snake")
	obstacle.set_pos(snakePos)
	obstacle.show()
	obstacle.set_scale(Vector2(scale.x/2,scale.y/2))
	get_parent().pause()
	count = 0
	type = 0

func breakWheel(rockPos, scale):
	# start timer for flashing
	get_node("On").start()
	# move icon to the proper position and show it
	obstacle = get_node("Rock")
	obstacle.set_pos(rockPos)
	obstacle.show()
	obstacle.set_scale(Vector2(scale.x/2,scale.y/2))
	get_parent().pause()
	count = 0
	type = 1

func killSnake(snakePos, scale):
	# start timer for flashing
	get_node("On").start()
	# move icon to the proper position and show it
	obstacle = get_node("Snake")
	obstacle.set_pos(snakePos)
	obstacle.show()
	obstacle.set_scale(Vector2(scale.x/2,scale.y/2))
	count = 0
	type = 2

func chiefGreet(chiefPos,teePos):
	get_node("On").set_wait_time(0.6)
	get_node("On").start()
	obstacle = get_node("Chief")
	var teepee = get_node("Teepee")
	teepee.set_pos(teePos)
	teepee.show()
	obstacle.set_pos(chiefPos)
	obstacle.show()
	count = 0
	type = 3

func _on_On_timeout():
	obstacle.hide()
	get_node("On").stop()
	if (count<flashes):
		get_node("Off").start()
		if (type==0):
			wagon.blinkAnimal()
		elif (type ==1):
			wagon.blinkWheel()
	else:
		# special treatment for snake animation
		if (type <2):
			get_parent().resume()
		else:
			queue_free()
	# special treatment for teepee+chief animation
	if (type==3):
		queue_free()

func _on_Off_timeout():
	obstacle.show()
	get_node("On").start()
	get_node("Off").stop()
	if (type==0):
		wagon.blinkAnimal()
	elif (type ==1):
		wagon.blinkWheel()
	count+=1

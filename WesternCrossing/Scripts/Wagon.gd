extends Node2D

const START_BULLETS = 20

# vertical position
var position
# number of live oxen
var animals
# is there a broken wheel?
var broken
# is the wagon dead
var dead
# number of bullets available
var bullets

# array of wheels
var wheels
# array of oxes
var oxen

func _ready():
	set_process_input(true)
	position = -1
	move_up()
	animals = 4
	broken = false
	dead = false
	bullets = START_BULLETS
	wheels=[get_node("Wagon/Wheels/Breakable"),get_node("Wagon/Wheels/WheelFront"),get_node("Wagon/Wheels/WheelBack")]
	wheels[1].play()
	wheels[2].play()
	var ox0 = get_node("Animals/CloseFront")
	var ox1 = get_node("Animals/FarFront")
	var ox2 = get_node("Animals/CloseBack")
	var ox3 = get_node("Animals/FarBack")
	oxen=[ox0,ox1,ox2,ox3]
	randomize()

func reset():
	# this automatically sorts size and position to center
	position = -1
	move_up()
	animals = 4
	broken = false
	dead = false
	bullets = START_BULLETS
	oxen[0].show()
	oxen[1].show()
	oxen[2].show()
	oxen[3].show()
	wheels[0].show()
	wheels[1].show()
	resume()

func _input(event):
	# for animation (pressing a key animates the button regardless of effect)
	if (event.is_action_pressed("ui_up")):
		get_parent().get_node("Up").press()
	elif (event.is_action_released("ui_up")):
		get_parent().get_node("Up").release()
	if (event.is_action_pressed("ui_down")):
		get_parent().get_node("Down").press()
	elif (event.is_action_released("ui_down")):
		get_parent().get_node("Down").release()
	# and in-game actions:
	if (event.is_action_pressed("ui_left")):
		get_parent().get_node("Shoot").press()
		if (get_parent().pause==false || (dead==true)):
			shoot()
	elif (event.is_action_released("ui_left")):
		get_parent().get_node("Shoot").release()
	if (dead || get_parent().pause==true):
		return
	# broken wheel make steering difficult (unless this is a visit to the teepee
	if (broken && !(position==1 && get_parent().get_node("MovingHorizon").visit==true)):
		if (randi()%2==1):
			return
	if (event.is_action_pressed("ui_up")):
		move_up()
	if (event.is_action_pressed("ui_down")):
		move_down()

func move_up():
	var node
	if (position==0):
		# move up
		position=1
		node = get_node("/root/World/Positions/Up")
	elif (position==-1):
		# move down
		position = 0
		node = get_node("/root/World/Positions/Middle")
	elif (position==1 && get_parent().get_node("MovingHorizon").visit==true):
		# visit teepee
		visitTeepee()
		return
	else:
		#nothing
		return
	set_pos(node.get_pos())
	set_scale(node.get_scale())
	
func move_down():
	var node
	if (position==1):
		position=0
		node = get_node("/root/World/Positions/Middle")
	elif (position==0):
		position = -1
		node = get_node("/root/World/Positions/Down")
	else:
		return
	set_pos(node.get_pos())
	set_scale(node.get_scale())

func kill_animal():
	# udpate counter
	if (animals>0):
		animals-=1
	# hide animals
	oxen[animals].hide()
	if (animals==0):
		dead = true
		pause()
		get_parent().pause()
		get_parent().get_node("RIP/RIPTimer").start()

func add_animal():
	# udpate counter
	if (animals<4):
		animals+=1
	# show animals
	oxen[animals-1].show()

func blinkAnimal():
	var animal = oxen[animals]
	if (animal.is_visible()):
		animal.hide()
	else:
		animal.show()

func breakWheel():
	if (broken==false):
		broken = true
		wheels[0].hide()
		wheels[1].stop()
	else:
		dead = true
		wheels[1].hide()
		pause()
		get_parent().pause()
		get_parent().get_node("RIP/RIPTimer").start()

func fixWheel():
	broken = false
	wheels[0].show()
	wheels[1].play()

func blinkWheel():
	var wheel
	if (dead):
		wheel = wheels[1]
	else:
		wheel = wheels[0]
	if (wheel.is_visible()):
		wheel.hide()
	else:
		wheel.show()

func pause():
	wheels[1].stop()
	wheels[2].stop()
	for i in range(0,4):
		oxen[i].get_node("AnimatedSprite").stop()

func resume():
	if (broken==false):
		wheels[1].play()
	wheels[2].play()
	for i in range(0,4):
		oxen[i].get_node("AnimatedSprite").play()

func getOxPos():
	return oxen[animals-1].get_pos()

func getWheelAbsolutePos():
	var pos = get_node("Wagon").get_pos()
	pos = Vector2(get_pos().x+pos.x,get_pos().y+pos.y)
	var wheel
	if (broken):
		wheel = wheels[1].get_pos()
	else:
		wheel = wheels[0].get_pos()
	pos = Vector2(pos.x+wheel.x,pos.y+wheel.y)
	return pos

func _on_Up_input_event( ev ):
	if (dead || get_parent().pause==true):
		return
	if (broken):
		if (randi()%2==1):
			return
	if (ev.is_pressed()):
		move_up()

func _on_Down_input_event( ev ):
	if (dead || get_parent().pause==true):
		return
	if (broken):
		if (randi()%2==1):
			return
	if (ev.is_pressed()):
		move_down()

func shoot():
	if (bullets==0):
		return
	get_node("Wagon/Pow").show()
	get_node("Wagon/Pow/PowTimer").set_wait_time(0.15)
	get_node("Wagon/Pow/PowTimer").start()
	bullets-=1
	get_parent().updateBullets(bullets)
	var obstacles = get_tree().get_nodes_in_group("Obstacles")
	for obstacle in obstacles:
		if (obstacle.position==position && obstacle.component.canBeShot()==true):
			var animation = preload("res://Scenes/Animator.tscn").instance()
			animation.killSnake(obstacle.get_pos(), obstacle.get_scale())
			obstacle.queue_free()
			get_tree().get_root().add_child(animation)
			# each shot can only kill one snake
			return

func _on_PowTimer_timeout():
	get_node("Wagon/Pow").hide()

func _on_Shoot_input_event( ev ):
	if (ev.is_pressed()):
		shoot()

func visitTeepee():
	if (broken):
		fixWheel()
	elif (animals<4):
		add_animal()
	else:
		bullets+=5
		get_parent().updateBullets(bullets)
	# tag teepee, can only use teepee once
	get_parent().get_node("MovingHorizon").visit=false
	# add chief animation
	var animation = preload("res://Scenes/Animator.tscn").instance()
	var chiefPos = get_parent().get_node("MovingHorizon/Chief").get_global_pos()
	var teepeePos = get_parent().get_node("Positions/Horizon/Teepee/Position5").get_global_pos()
	animation.chiefGreet(chiefPos,teepeePos)
	get_tree().get_root().add_child(animation)

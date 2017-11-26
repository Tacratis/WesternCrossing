extends Node2D

# pause in-game (for animation)
var pause
# pause the game itself (for breaks)
var gamePause
# distance travelled
var miles

func _ready():
	pause = false
	gamePause=false
	reset()

func _on_Generator_timeout():
	var chance = randf()
	if (chance<0.65):
		var newO = preload("res://Scenes/Obstacle.tscn").instance()
		# random position
		var random = randi()%3-1
		# scale
		var scale
		if (random==-1):
			scale = get_node("Positions/Down").get_scale()
		elif (random==0):
			scale = get_node("Positions/Middle").get_scale()
		elif (random==1):
			scale = get_node("Positions/Up").get_scale()
		get_tree().get_root().add_child(newO)
		var type = randi()%2
		var child
		if (type==0):
			child = preload("res://Scenes/Snake.tscn").instance()
		else:
			child = preload("res://Scenes/Rock.tscn").instance()
		newO.add_child(child)
		newO.addBehavior(child)
		newO.create(random,scale)
	# add distance travelled
	miles+=1
	updateMiles(miles)

func pause():
	pause = true
	get_node("Wagon").pause()
	get_node("Generator").stop()
	var group = get_tree().get_nodes_in_group("Obstacles")
	for node in group:
		node.pause()

func resume():
	var wagon = get_node("Wagon")
	if (wagon.animals==0 || wagon.dead):
		return
	pause = false
	get_node("Wagon").resume()
	get_node("Generator").start()
	var group = get_tree().get_nodes_in_group("Obstacles")
	for node in group:
		node.resume()

func reset():
	# remove all existing elements
	var group = get_tree().get_nodes_in_group("Obstacles")
	for node in group:
		node.queue_free()
	# reset the wagon
	var wagon = get_node("Wagon")
	wagon.reset()
	updateBullets(wagon.bullets)
	# update animator
	get_node("Animator").reset()
	#resume game
	resume()
	# reset moving horizon stuff
	get_node("MovingHorizon").reset()
	# remove pause (if reseting from a paused state)
	gamePause = false
	# reset RIP
	get_node("RIP").hide()
	get_node("RIP/RIPTimer").stop()
	# reset all buttons
	get_node("Shoot").release()
	get_node("Up").release()
	get_node("Down").release()
	get_node("Pause").release()
	# update mileage
	miles = 0
	updateMiles(miles)

func _on_Control_input_event( ev ):
	if (ev.is_pressed()):
		reset()
		get_tree().set_pause(false)

func _on_Pause_input_event( ev ):
	if (ev.is_pressed()):
		gamePause()

func gamePause():
	if (gamePause):
		gamePause = false
		get_tree().set_pause(false)
	else:
		gamePause = true
		get_tree().set_pause(true)


func _on_RIPTimer_timeout():
	get_node("RIP").show()

func updateBullets(bullets):
	var present
	if (bullets>99):
		present = 99
	else:
		present = bullets
	var tens = present/10
	if (tens>0):
		get_node("Bullets/Tens").show()
		get_node("Bullets/Tens").set_value(tens)
	else:
		get_node("Bullets/Tens").hide()
	var ones = present-tens*10
	get_node("Bullets/Ones").set_value(ones)

func updateMiles(miles):
	var present
	if (miles>999):
		present = 999
	else:
		present = miles
	# hundreds (C for roman 100)
	var Cs = present/100
	if (Cs>0):
		get_node("Mileage/Cs").show()
		get_node("Mileage/Cs").set_value(Cs)
	else:
		get_node("Mileage/Cs").hide()
	var tens = (present-Cs*100)/10
	if (tens>0 || Cs>0):
		get_node("Mileage/Tens").show()
		get_node("Mileage/Tens").set_value(tens)
	else:
		get_node("Mileage/Tens").hide()
	var ones = present-Cs*100-tens*10
	get_node("Mileage/Ones").set_value(ones)

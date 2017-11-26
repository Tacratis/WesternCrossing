extends Node2D

# station is the horizontal position on the screen, where 0 is the wagon (last station)
var station
# position is the vertical position (up, middle, down)
var position
# type of obstacle and behavoir (composition)
var component
# the wagon
var wagon

func _ready():
	set_process(true)
	wagon = get_node("/root/World/Wagon")
	
func create(pos,scale):
	position = pos
	set_scale(scale)
	station = component.getStation(position)
	move_to_station(station)

func _process(delta):
	if (station==0 && position==wagon.position):
		component.touchWagon(get_pos())

func addBehavior(node):
	component = node

func _on_Timer_timeout():
	if (station>0):
		station-=1
		move_to_station(station)
	else:
		queue_free()

func move_to_station(number):
	set_pos(component.getStationPos(position,station))
	# last station check hit
	if (station==0 && position==wagon.position):
		component.reachWagon(get_pos())
	elif (station==1):
		# shorten the timer
		# this is important to allow strafing through adjacent snakes
		# I couldn't figure out why, but this needs to be done at station 1 to affect the time spent at station 0
		var time = get_node("Timer").get_wait_time()
		get_node("Timer").set_wait_time(time/3)

func pause():
	get_node("Timer").stop()
	component.pause()

func resume():
	get_node("Timer").start()
	component.resume()

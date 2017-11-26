extends Node2D

var up
var middle
var down 

func _ready():
	var obstacles = get_node("/root/World/Positions/Up/Obstacles")
	
	var up0 = obstacles.get_node("Snake0").get_global_pos()
	var up1 = obstacles.get_node("Snake1").get_global_pos()
	var up2 = obstacles.get_node("Snake2").get_global_pos()
	var up3 = obstacles.get_node("Snake3").get_global_pos()
	var up4 = obstacles.get_node("Snake4").get_global_pos()
	var up5 = obstacles.get_node("Snake5").get_global_pos()
	up = [up0,up1, up2, up3, up4, up5]
	
	obstacles = get_node("/root/World/Positions/Middle/Obstacles")
	var middle0 = obstacles.get_node("Snake0").get_global_pos()
	var middle1 = obstacles.get_node("Snake1").get_global_pos()
	var middle2 = obstacles.get_node("Snake2").get_global_pos()
	var middle3 = obstacles.get_node("Snake3").get_global_pos()
	var middle4 = obstacles.get_node("Snake4").get_global_pos()
	middle = [middle0,middle1, middle2, middle3, middle4]
	
	obstacles = get_node("/root/World/Positions/Down/Obstacles")
	var down0 = obstacles.get_node("Snake0").get_global_pos()
	var down1 = obstacles.get_node("Snake1").get_global_pos()
	var down2 = obstacles.get_node("Snake2").get_global_pos()
	var down3 = obstacles.get_node("Snake3").get_global_pos()
	down = [down0,down1, down2, down3]
	
func reachWagon(position):
	touchWagon(position)

func touchWagon(position):
	var wagon = get_node("/root/World/Wagon")
	get_node("/root/World/Animator").killOx(position, wagon.get_scale())
	wagon.kill_animal()
	get_parent().queue_free()

func getStation(position):
	if (position==1):
		return 5
	elif (position==0):
		return 4
	elif (position==-1):
		return 3

func getStationPos(position,station):
	if (position==1):
		return(up[station])
	elif (position==0):
		return(middle[station])
	elif (position==-1):
		return(down[station])

func pause():
	# snakes still move when the wagon is not moving
	pass

func resume():
	pass

func canBeShot():
	return true

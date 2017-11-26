extends Node2D

var up0
var up1
var up2
var up3
var up4
var up5
var up6
var up

var middle0 
var middle1
var middle2 
var middle3
var middle4
var middle5
var middle6
var middle

var down0 
var down1 
var down2
var down3 
var down4
var down 

func _ready():
	var obstacles = get_node("/root/World/Positions/Up/Obstacles")
	
	up0 = obstacles.get_node("Rock0").get_global_pos()
	up1 = obstacles.get_node("Rock1").get_global_pos()
	up2 = obstacles.get_node("Rock2").get_global_pos()
	up3 = obstacles.get_node("Rock3").get_global_pos()
	up4 = obstacles.get_node("Rock4").get_global_pos()
	up5 = obstacles.get_node("Rock5").get_global_pos()
	up6 = obstacles.get_node("Rock6").get_global_pos()
	up = [up0,up1, up2, up3, up4, up5, up6]
	
	obstacles = get_node("/root/World/Positions/Middle/Obstacles")
	middle0 = obstacles.get_node("Rock0").get_global_pos()
	middle1 = obstacles.get_node("Rock1").get_global_pos()
	middle2 = obstacles.get_node("Rock2").get_global_pos()
	middle3 = obstacles.get_node("Rock3").get_global_pos()
	middle4 = obstacles.get_node("Rock4").get_global_pos()
	middle5 = obstacles.get_node("Rock5").get_global_pos()
	middle = [middle0,middle1, middle2, middle3, middle4, middle5]
	
	obstacles = get_node("/root/World/Positions/Down/Obstacles")
	down0 = obstacles.get_node("Rock0").get_global_pos()
	down1 = obstacles.get_node("Rock1").get_global_pos()
	down2 = obstacles.get_node("Rock2").get_global_pos()
	down3 = obstacles.get_node("Rock3").get_global_pos()
	down4 = obstacles.get_node("Rock4").get_global_pos()
	down = [down0,down1, down2, down3, down4]

func reachWagon(position):
	var wagon = get_node("/root/World/Wagon")
	get_node("/root/World/Animator").breakWheel(position, wagon.get_scale())
	wagon.breakWheel()
	get_parent().queue_free()

func touchWagon(position):
	pass

func getStation(position):
	if (position==1):
		return 6
	elif (position==0):
		return 5
	elif (position==-1):
		return 4
	
func getStationPos(position,station):
	if (position==1):
		return(up[station])
	elif (position==0):
		return(middle[station])
	elif (position==-1):
		return(down[station])

func pause():
	pass

func resume():
	pass

func canBeShot():
	return false

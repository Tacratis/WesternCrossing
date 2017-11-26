extends Node2D

# array of mountain positions
var mountain
# array of river positions
var river
# array of teepee positions
var teepee
# index for current position
var index
# type of animation to show (moving mountain, moving river, or both)
var type
const NONE = 0
const MOUNTAIN = 1
const RIVER = 2
const BOTH = 3
const TEEPEE = 4
# flag for whether teepee is in position to visit
var visit

func _ready():
	var base = get_node("/root/World/Positions/Horizon/Mountain")
	var pos1 = base.get_node("Position1").get_global_pos()
	var pos2 = base.get_node("Position2").get_global_pos()
	var pos3 = base.get_node("Position3").get_global_pos()
	var pos4 = base.get_node("Position4").get_global_pos()
	var pos5 = base.get_node("Position5").get_global_pos()
	mountain = [pos1,pos2,pos3,pos4,pos5]
	
	base = get_node("/root/World/Positions/Horizon/River")
	var pos1 = base.get_node("Position1").get_global_pos()
	var pos2 = base.get_node("Position2").get_global_pos()
	var pos3 = base.get_node("Position3").get_global_pos()
	var pos4 = base.get_node("Position4").get_global_pos()
	var pos5 = base.get_node("Position5").get_global_pos()
	river = [pos1,pos2,pos3,pos4,pos5]
	
	base = get_node("/root/World/Positions/Horizon/Teepee")
	var pos1 = base.get_node("Position1").get_global_pos()
	var pos2 = base.get_node("Position2").get_global_pos()
	var pos3 = base.get_node("Position3").get_global_pos()
	var pos4 = base.get_node("Position4").get_global_pos()
	var pos5 = base.get_node("Position5").get_global_pos()
	teepee = [pos1,pos2,pos3,pos4,pos5]
	
	reset()
	
func reset():
	type = NONE
	get_node("Mountain").hide()
	get_node("River").hide()
	get_node("Teepee").hide()
	index = 0
	visit = false

func _on_Generator_timeout():
	if (type==NONE):
		# randomly generate a new animation
		var random  = randf()
		if (random<0.05):
			type = MOUNTAIN
			get_node("Mountain").show()
			get_node("Mountain").set_pos(mountain[index])
		elif (random<0.1):
			type = RIVER
			get_node("River").show()
			get_node("River").set_pos(river[index])
		elif (random<0.15):
			type = BOTH
			get_node("Mountain").show()
			get_node("River").show()
			get_node("Mountain").set_pos(mountain[index])
			get_node("River").set_pos(river[index])
		elif (random<0.2):
			type = TEEPEE
			get_node("Teepee").show()
			get_node("Teepee").set_pos(teepee[index])
	else:
		if (index>=4):
			type = NONE
			get_node("Mountain").hide()
			get_node("River").hide()
			get_node("Teepee").hide()
			index = 0
			visit = false
		else:
			index+=1
			get_node("Mountain").set_pos(mountain[index])
			get_node("River").set_pos(river[index])
			get_node("Teepee").set_pos(teepee[index])
			if (type==TEEPEE && index==4):
				visit = true

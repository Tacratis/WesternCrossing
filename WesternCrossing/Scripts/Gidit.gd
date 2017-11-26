extends Node2D

# value this number should desplay
var value
# array of sprites
var sprites
# array of booleans
var array

func _ready():
	# 1d array of sprites
	var s0 = get_node("0")
	var s1 = get_node("1")
	var s2 = get_node("2")
	var s3 = get_node("3")
	var s4 = get_node("4")
	var s5 = get_node("5")
	var s6 = get_node("6")
	sprites = [s0,s1,s2,s3,s4,s5,s6]
	
	# 2d array of booleans array[0-9][sprite0-6]
	var a0 = [true,false,true,true,true,true,true]
	var a1 = [false,false,false,false,true,false,true]
	var a2 = [true,true,true,false,true,true,false]
	var a3 = [true,true,true,false,true,false,true]
	var a4 = [false,true,false,true,true,false,true]
	var a5 = [true,true,true,true,false,false,true]
	var a6 = [true,true,true,true,false,true,true]
	var a7 = [true,false,false,false,true,false,true]
	var a8 = [true,true,true,true,true,true,true]
	var a9 = [true,true,true,true,true,false,true]
	
	array = [a0,a1,a2,a3,a4,a5,a6,a7,a8,a9]
	
	value = 0

func set_value(num):
	value = num
	var booleans = array[value]
	for i in range (0,7):
		if (booleans[i]==true):
			sprites[i].show()
		else:
			sprites[i].hide()

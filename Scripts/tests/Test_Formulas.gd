extends Node

func _ready():
	#This logic isuse to get the area of grid
	var height = 34
	var Position = 120
	var modi = Position % height
	
	print(Position," mod 34 = ", modi)
	var currblock = (Position - modi)/height
	print("Current Block = ", currblock, " Pos = ", (Position - modi))
	var nextblock = ((Position - modi)+height)/height
	print("Next Block = ", nextblock, " Pos = ", ((Position - modi)+height))
	print("Next Block = ", currblock +1, " Pos = ", (Position - modi)+height)

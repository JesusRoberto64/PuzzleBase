extends Node2D

var colums = 5
var rows = 8
var tileSize

var tiles = []
var tilesArray = []
var number_Tiles : int = 5

var selected = Vector2(0,0)

@onready var SprSelector = $selector
@onready var SprTiles = $tiles
@onready var Block = $block

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(rows):
		tiles.append([])
		tilesArray.append([])
		for y in range(colums):
			tiles[x].append(0)
			pass
		pass
	
	for r in range(rows):
		for c in range(colums):
			tiles[r][c] =  randi() % (number_Tiles)
			while (r>0 and tiles[r][c] == tiles[r-1][c]) or (c>0 and tiles[r][c] == tiles[r][c-1]):
				tiles[r][c] = randi() % (number_Tiles)
	
	# SET UP
	tileSize = $block.texture.get_height()
	
	for r in range(rows):
		for c in range(colums):
			var newBlock: Sprite2D = $block.duplicate()
			newBlock.position = Vector2(c,r)*tileSize
			newBlock.frame = tiles[r][c]
			SprTiles.add_child(newBlock)
			tilesArray[r].append(newBlock)
			pass 
	
	$block.hide()

func check_Matches():
	var matches = []
	for c in range(colums):
		var currentMatch = []
		for r in range(rows):
			tilesArray[r][c].position = Vector2(c,r)*tileSize # Put sprites in new psotion
			if currentMatch == [] or tiles[r][c] == tiles[r - 1][c]:
				currentMatch.append(Vector2(r,c))
			else:
				if currentMatch.size() >= 3:
					matches.append(currentMatch)
				currentMatch = [Vector2(r,c)]
		if currentMatch.size() >= 3:
			matches.append(currentMatch)
	
	for r in range(rows):
		var currentMatch = []
		for c in range(colums):
			
			if currentMatch == [] or tiles[r][c] == tiles[r][c - 1]:
				currentMatch.append(Vector2(r,c))
			else:
				if currentMatch.size() >= 3:
					matches.append(currentMatch)
				currentMatch = [Vector2(r,c)]
		if currentMatch.size() >= 3:
			matches.append(currentMatch)
	return matches

func clear_Matches(matches):
	print("===================================")
	for i in tiles:
		print(i)
	for mat in matches:
		for pos in mat:
			tiles[pos.x][pos.y] = null 
			tilesArray[pos.x][pos.y].hide()
	print("===================================")
	for i in tiles:
		print(i)
	print("===================================")
	if matches.size() > 0:
		print(matches)

func fill_Board():
	for c in range(colums):
		for r in range(rows):
			if tiles[r][c] == null:
				for rr in range(r,0,-1):
					tiles[rr][c] = tiles[rr - 1][c]
				#=========
				tiles[0][c] = null
				#tiles[0][c] = randi() % (number_Tiles)
#				while tiles[0][c] == tiles[1][c] or (c>0 and 
#tiles[0][c] == tiles[0][c-1]) or (c>colums-1 and tiles[0][c] == tiles[0][c+1]):
#					tiles[0][c] = randi() % (number_Tiles)
				tilesArray[r][c].show()
			pass
	print("brake")
	for c in range(colums):
		for r in range(rows):
			if tiles[r][c] == null:
				tilesArray[r][c].hide()
			else:
				tilesArray[r][c].frame = tiles[r][c]
#			if tiles[r][c] == null:
#				tilesArray[r][c].hide()
#			else:
#				tilesArray[r][c].frame = tiles[r][c]
#				tilesArray[r][c].show()
#			pass
	print("=================================== End")
	for i in tiles:
		print(i)
	
	#Combo 
	var combo = check_Matches()
	if check_Matches().size() > 0:
		clear_Matches(combo)
	
	pass

func _input(event):
	if event.is_action_pressed("ui_left"): # Need game feel 
		selected.x = max(0, selected.x -1)
		SprSelector.position.x = selected.x * tileSize
	if event.is_action_pressed("ui_right"):
		selected.x = min(selected.x + 1, colums-2)
		SprSelector.position.x = selected.x * tileSize
	if event.is_action_pressed("ui_up"):
		selected.y = max(0, selected.y -1)
		SprSelector.position.y = selected.y * tileSize
	if event.is_action_pressed("ui_down"):
		selected.y = min(selected.y + 1, rows-1)
		SprSelector.position.y = selected.y * tileSize
	
	if event.is_action_pressed("ui_accept"):
		#var flipR = tiles[selected.y][selected.x + 1]
		var flipL = tiles[selected.y][selected.x]
		tiles[selected.y][selected.x] = tiles[selected.y][selected.x + 1]
		tiles[selected.y][selected.x + 1] = flipL
		
		var flipLPos = tilesArray[selected.y][selected.x]
		tilesArray[selected.y][selected.x] = tilesArray[selected.y][selected.x+1]
		tilesArray[selected.y][selected.x+1] = flipLPos
		
		var matches = check_Matches()
		clear_Matches(matches)
		fill_Board()
		pass
	pass

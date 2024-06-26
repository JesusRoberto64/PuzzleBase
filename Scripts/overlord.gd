extends Node2D
# Es que el fondo se pinte cuando haces match, completas la imagen y ganas
# La cubeta es compartida (stack)
# Hacer el player 2-3-4
enum STATE {GAME, LOSE, PAUSE}

var state = STATE.GAME
@onready var Proto = preload("res://Entities/Proto_Bloc.tscn")

var colums = 12#6#12
var rows = 8
var blocH 
var blocW
var blocColors = 7

@onready var Blocs = $Bloques
var arrMatch = []
var number_Tiles : int = 5
var highPos

#cycle
@export var velCycle = 20.0
@export var velGrav = 0 # grave only PRIME NUMBERS of texture height
var velocities = []
var limitCycle = 0.5 #Play the lowest to faster 0.5
var cycle = 0
var createCycle = 10 # Play the lowest to faster 20
var multCycle = 5
var countCycle = 0

var debug_Blocs = 0
#Selector 
@onready var Selector = $Selector

var canCast = false
var castPos = Vector2.ZERO
var castColor 

var Stacks

#Ghost to check This was made to have a visual feedbak to the arrays -->Cont
#when blocks are falling, becouse the absorb a cast mechanics have bugs
@onready var ghosts = $Ghosts

#Inti the pictures
@onready var picto = $PictBloc

func _ready():
	for x in range(rows): # Remember rows = is the first [r]
		arrMatch.append([])# Remember colums = is the second[r][c]
		for y in range(colums):
			arrMatch[x].append(null)
	#Set bloc's measures
	var sizes = $Proto.get_Sizes()
	blocH = int(sizes.x)#$Proto/Sprite2D.texture.get_height()
	blocW = int(sizes.y)#$Proto/Sprite2D.texture.get_width()/ $Proto/Sprite2D.hframes
	
	Engine.max_fps = 70
	
	#SET THE PRIME NUMBERS
	for i in range(1,blocH):
		if blocH % i == 0:
			velocities.append(i)
	velGrav = velocities[4]
	#Player ready for action
	selector_Set(Selector)
	
	if get_tree().get_first_node_in_group("Stack"):
		Stacks = get_tree().get_nodes_in_group("Stack")
	#Init Ghosts
	ghosts._draw_Blocs(arrMatch, Vector2(blocW,blocH))
	#Init Picto
	picto._set_Array(arrMatch, Vector2(blocW,blocH))
	picto.set_Image()
	
	#Create the firsts blocs
	create_Initial_Blocs()
	

func _process(delta):
	#print("FPS: ",Engine.get_frames_per_second())
	if state != STATE.GAME : return
	#The cycles to create blocks from upper part
	if countCycle >= createCycle*multCycle or Input.is_action_just_released("trow"):
		countCycle = 0
		#check the upper line
		var freeSpace = top_Free()
		if freeSpace == null:
			print("=========you lose======")
			state = STATE.LOSE
		else:
			create_Bloc(Vector2(blocW*freeSpace,-blocH))
	#Normal Cycle
	cycle += delta*velCycle
	if cycle >= limitCycle:
		cycle = 0
		countCycle += 1 #This control the create bloc cycle
		if canCast:
			canCast = false
			create_Bloc_Color(castPos,castColor)
		destroy_Blocs()#1 iteración
		gravity()# 1 iteratio
		check_Matches()# 2 iterations
		

func top_Free():
	var spaces = []
	for c in range(colums):
		if arrMatch[0][c] == null:
			spaces.append(c)
	if spaces.size() <= 0: return null
	if spaces.size() < 2: return spaces[0] 
	#DEBUG sustutute debugBlocs to randi()!!!================
	return spaces[debug_Blocs % spaces.size()]

func create_Bloc(_pos: Vector2):
	var newBloc = Proto.instantiate()
	var _debugArr = [0,4,4,4,4,3,3,3]
	var color = randi() % blocColors#randi() % blocColors #_debugArr[debug_Blocs % _debugArr.size()]
	debug_Blocs += 1
	newBloc.set_Color(Vector2(color,0))#get_child(0).frame_coords = Vector2(color,0)
	newBloc.position = _pos
	Blocs.add_child(newBloc)
	newBloc.casted()

func create_Bloc_Color(_pos: Vector2, _color):
	var newBloc = Proto.instantiate()
	newBloc.set_Color(Vector2(_color,0))
	newBloc.position = _pos
	Blocs.add_child(newBloc)
	newBloc.casted()

func create_Initial_Blocs():
	var rowsHeight = 3
	for c in range(colums):
		#from the maximun rows -1 to have the start then goes to 3 rows because
		# the second number is exlcuded. In other words: (how many rows height)+1? 
		for r in range(rows-1,rowsHeight+1,-1): #Check dcumentation range
			create_Bloc(Vector2(c*blocW, r*blocH))

func gravity():
	for i in Blocs.get_children():
		# Convert to matchArr
		var Pos = Vector2(i.position.x/blocW, i.position.y/blocH)# Remember invert arrMAtch[y][x]
		#Here we get the actual row but not at the begining nor the end of array
		#It prevests array the typical array get an indx greater than array size. 
		if Pos.y < (rows-1) and Pos.y > 0: 
			#In this block just apear the next bloc and despear the previos one
			#this is the way we monitoring were is a bloc when is falling
			ghosts.show_Bloc(Vector2(Pos.x, Pos.y + 1))
			ghosts.blocs[Pos.y + 1][Pos.x] = i 
			ghosts.hide_Bloc(Vector2(Pos.x, Pos.y - 1))
			ghosts.blocs[Pos.y - 1][Pos.x] = null
		
		if i.Solid == true: 
			ghosts.hide_Bloc(Pos) #Got to reset the bloc when its not falling
			if i.position.y == blocH*(rows-1):#Is Bloc on floor?
				#This is kind of brute force to avoid ghost with no bloc
				#To hide upper bloc when toching the ground
				ghosts.hide_Bloc(Vector2(Pos.x, Pos.y - 1))
				ghosts.blocs[Pos.y - 1][Pos.x] = null
				continue 
			elif arrMatch[Pos.y + 1][Pos.x] != null: #Is Bloc Below?
				#This is kind of brute force hide the bloc bleow
				ghosts.hide_Bloc(Vector2(Pos.x, Pos.y + 1))
				ghosts.blocs[Pos.y +1][Pos.x] = null
				continue
			elif  i.IsMatched:
				#This is kind of brute force to hide the bloc bleow
				ghosts.hide_Bloc(Vector2(Pos.x, Pos.y + 1))
				ghosts.blocs[Pos.y + 1][Pos.x] = null
				continue
			else:
				i.Solid = false
				arrMatch[Pos.y][Pos.x] = null
		
		#Check if is about to reach the floor
		if i.position.y + blocH + velGrav >= blocH*(rows):
			i.position.y = blocH*(rows-1)
			arrMatch[rows-1][Pos.x] = i#.get_child(0).frame_coords.x
			i.Solid = true
			#check_Matches()
			continue
		
		# Check current area made by blocs
		var modi = int(i.position.y) % blocH # get the remainig of the area: How much pixels for the multiply number(Height)?
		var currArea = (i.position.y - modi)/blocH # get the convertion of area in wich the bloc is, --> continue below
		# due to reference it on the match Array.  
		var currPos = i.position.y - modi # the current Multiply position in pixels No matter if its offset --> continue below
		# thats the reason we are substractig: to get the pixel position of the lesser and closer multiply
		var nextPos = (i.position.y - modi)+blocH # the next of the current Multiply in pixels
		if i.position.y + blocH + velGrav >= nextPos: # if is about to collide
			if arrMatch[currArea + 1][Pos.x] == null:
				i.position.y += velGrav
			else:
				i.position.y = currPos
				arrMatch[Pos.y][Pos.x] = i #.get_child(0).frame_coords.x
				i.Solid = true
				#check_Matches()
		else:
			i.position.y += velGrav

func selector_Set(_selector):#For the two players 
	_selector.offset = Blocs.position
	_selector.set_Up_Blocs(Vector2(blocW,blocH),Vector2(colums,rows),self)

func selector_Act(_player, _pos: Vector2):
	if state != STATE.GAME : return
	var bloc = arrMatch[_pos.y/blocH][_pos.x/blocW]
	var stack = Stacks[_player.playerID-1]
	#To cnvert in array form and easy to manipulate to the ghost fuctions
	var pos = Vector2(_pos.x/blocH, _pos.y/blocW)
	if !stack.is_Full(): 
		# ABSOBR =============
		if ghosts.is_Bloc_Falling(pos) and ghosts.get_Bloc(pos):
			var b = ghosts.get_Bloc(pos)
			stack.add_Bloc(b.get_Color())
			ghosts.free_Bloc(pos)
			ghosts.hide_Bloc(pos)
			ghosts.hide_Bloc(Vector2(pos.x, pos.y -1))
			if pos.y < rows-1: #Here to dont cause erros in array size.
				ghosts.hide_Bloc(Vector2(pos.x, pos.y +1))
			_player.can_Move()
			return
		elif bloc != null and !bloc.IsMatched:
			stack.add_Bloc(bloc.get_Color())
			bloc.queue_free()
			arrMatch[_pos.y/blocH][_pos.x/blocW] = null
			_player.can_Move()
			return
	# CAST ============
	if stack.have_Blocs() and !ghosts.is_Bloc_Falling(pos) and bloc == null:
		cast_Bloc(Vector2(_pos.x,_pos.y),stack.cast_Bloc())
		_player.cast() #ANIM
	_player.can_Move()
	return

func cast_Bloc(_pos, _color):
	for i in Blocs.get_children():
		if i.position.x == _pos.x:
			if i.position.y > _pos.y - blocH and i.position.y < _pos.y + blocH:
				return
	canCast = true
	castPos = _pos
	castColor = _color

func check_Matches():
	var matches = []
	for c in range(colums):
		var currentMatch = []
		for r in range(rows):
			if arrMatch[r][c] == null : continue
			if  arrMatch[r-1][c] == null: #and currentMatch == []:
				currentMatch.append(Vector2(r,c))
			elif currentMatch == [] or arrMatch[r][c].get_Color() == arrMatch[r-1][c].get_Color():
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
			if arrMatch[r][c] == null : 
				if currentMatch.size() >= 3:
					matches.append(currentMatch)
			elif c-1 == -1: #At the begining 
				currentMatch.append(Vector2(r,c))
			elif arrMatch[r][c-1] == null:
				currentMatch = []
				currentMatch.append(Vector2(r,c))
			elif currentMatch == [] or arrMatch[r][c].get_Color() == arrMatch[r][c-1].get_Color():
				currentMatch.append(Vector2(r,c))
			else:
				if currentMatch.size() >= 3:
					matches.append(currentMatch)
				currentMatch = [Vector2(r,c)]
		if currentMatch.size() >= 3:
			matches.append(currentMatch)
	if matches.size() > 0:
		clear_Matches(matches) 

func clear_Matches(matches):
	for mat in matches:
		for pos in mat:
			if arrMatch[pos.x][pos.y] != null:
				arrMatch[pos.x][pos.y].matched()
				#get the picto
				picto.break_Pict(Vector2(pos.y, pos.x))

func destroy_Blocs():
	for c in range(colums):
		for r in range(rows):
			if arrMatch[r][c] == null: continue
			if arrMatch[r][c].destroyed:
				arrMatch[r][c].queue_free()
				arrMatch[r][c] = null

func _input(event):
	if Input.is_key_pressed(KEY_5):
		get_tree().reload_current_scene()
		pass
	
	if event.is_action_pressed("ui_accept"):
		if state == STATE.PAUSE:
			state = STATE.GAME
			return
		print("============================")
		for x in arrMatch:
			var Currarray = []
			for y in x: 
				if y != null:
					Currarray.append(y.get_Color())
				else:
					Currarray.append("Null")
			print(Currarray)
		state = STATE.PAUSE

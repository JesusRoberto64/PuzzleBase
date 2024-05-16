extends Node2D

@onready var capacity = get_children().size()
@export var playerID = 1
var blocs = 0

var stack = []

func _ready():
	for i in capacity:
		get_child(i).hide()
		stack.append(null)

func add_Bloc(_color):
	blocs += 1
	stack[blocs-1] = _color
	for i in get_children():
		i.hide()
		if stack[i.get_index()] == null: break
		i.frame_coords.x = stack[i.get_index()]
		i.show()

func cast_Bloc(): #from the first index of stak array
	# from up to Button
	var color = stack[blocs-1]
	stack[blocs-1] = null
	blocs -= 1
	
	for i in capacity:
		get_child(i).hide()
		if stack[i] == null: break
		get_child(i).frame_coords.x = stack[i]
		get_child(i).show()
	
	return color

func is_Full():
	if blocs >= capacity: 
		return true
	else:
		return false

func have_Blocs():
	if blocs == 0:
		return false
	else:
		return true

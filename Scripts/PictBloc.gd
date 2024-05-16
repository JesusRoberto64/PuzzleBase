extends Node2D

@export var pictoArray: Array
@onready var proto = $ProtoPict
@export var blocs :Array= []
#Remember hoe to get the colums and rows
# colums = map.size() # rows = map[0].size()
var map:Array= [
	[0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0],
	[1, 1, 0, 0, 0, 0],
	[1, 1, 1, 0, 0, 0],
	[0, 1, 1, 0, 0, 0],
	[0, 1, 1, 1, 0, 0],
	[0, 1, 1, 1, 1, 0]
]

func _set_Array(array: Array, dimetions: Vector2):
	for x in range(array.size()):
		pictoArray.append([])
		for y in range(array[x].size()):
			var p = proto.duplicate()
			p.position = Vector2(y*dimetions.y, x*dimetions.x)
			p.visible = false
			add_child(p)
			pictoArray[x].append(p)

func set_Image():
	for c in range(map.size()):
		for r in range(map[c].size()):
			if map[c][r] == 1:
				pictoArray[c][r].visible = true

func break_Pict(pos: Vector2):
	if pos.x >= map[0].size() or pos.y >= map.size():  
		return
	if map[pos.y][pos.x] != 0:
		map[pos.y][pos.x] = 0
		pictoArray[pos.y][pos.x].visible = false

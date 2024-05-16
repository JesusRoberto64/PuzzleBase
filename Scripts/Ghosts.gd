extends Node2D

@export var ghostArray: Array
@onready var proto = $ProtoGhost
@export var blocs :Array= []

func _draw_Blocs(array: Array, dimetions: Vector2):
	for x in range(array.size()):
		blocs.append([])
		ghostArray.append([])
		for y in range(array[x].size()):
			var g = proto.duplicate()
			g.position = Vector2(y*dimetions.y, x*dimetions.x)
			g.visible = false
			add_child(g)
			ghostArray[x].append(g)
			blocs[x].append(null)
			pass
		pass
	pass

func show_Bloc(pos: Vector2):
	ghostArray[pos.y][pos.x].visible = true
	pass

func hide_Bloc(pos: Vector2):
	ghostArray[pos.y][pos.x].visible = false

func is_Bloc_Falling(pos:Vector2):
	if ghostArray[pos.y][pos.x].visible == false:
		return false
	else:
		return true

func get_Bloc(pos: Vector2):
	if blocs[pos.y][pos.x] != null:
		return blocs[pos.y][pos.x]
	return null

func free_Bloc(pos: Vector2):
	ghostArray[pos.y][pos.x].visible = false
	blocs[pos.y][pos.x].queue_free()
	blocs[pos.y][pos.x] = null
	pass

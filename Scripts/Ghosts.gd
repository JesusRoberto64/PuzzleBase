extends Node2D

@export var ghostArray: Array
@onready var proto = $ProtoGhost

func _draw_Blocs(array: Array, dimetions: Vector2):
	for x in range(array.size()):
		ghostArray.append([])
		for y in range(array[x].size()):
			var g = proto.duplicate()
			g.position = Vector2(y*dimetions.y, x*dimetions.x)
			g.visible = false
			add_child(g)
			ghostArray[x].append(g)
			pass
		pass
	pass

func show_Bloc(pos: Vector2):
	ghostArray[pos.y][pos.x].visible = true
	pass

func hide_Bloc(pos: Vector2):
	ghostArray[pos.y][pos.x].visible = false

func is_Bloc_Fallling(pos:Vector2):
	if ghostArray[pos.y][pos.x].visible == false:
		print("FREE SPACE")
		return false
	else:
		print("ITS BLOC DUUD")
		return true

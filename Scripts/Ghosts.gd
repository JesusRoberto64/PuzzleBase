extends Node2D

@export var ghostArray: Array

func _draw_Blocs(array: Array, proto:Sprite2D, dimetions: Vector2):
	ghostArray = array
	for x in range(array.size()):
		ghostArray.append([])
		for y in range(array[x].size()):
			var g = proto.duplicate()
			g.position = Vector2(y*dimetions.y, x*dimetions.x)
			#g.visible = false
			add_child(g)
			ghostArray[x].append(g)
			pass
		pass
	pass

func show_Bloc(pos: Vector2):
	ghostArray[pos.y][pos.x + 1].visible = true
	pass

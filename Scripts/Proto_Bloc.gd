extends Area2D

@export var Solid = false
@onready var color = $Pivot/Sprite2D

var IsMatched := false
var destroyed = false


func get_Sizes()->Vector2:
	var x = color.texture.get_width()/color.hframes
	var y = color.texture.get_height()
	return Vector2(x,y)

func get_Color():
	if IsMatched: return 99# Due to dont match with other new blocs
	return color.frame_coords.x

func set_Color(_color):
	var c = $Pivot/Sprite2D
	c.frame_coords = _color

func matched():
	$anim.play("destroy")
	IsMatched = true

func casted():
	$anim.play("cast")

func _on_anim_animation_finished(anim_name):
	if anim_name == "destroy":
		destroyed = true

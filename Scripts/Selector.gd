extends Sprite2D

enum  STATE {MOVE,ACTION,ABSORB,DROP}
var state = STATE.MOVE

var blocSize :Vector2 = Vector2(1,1)
var arenaSize: Vector2 = Vector2(10,10)

signal action(player,Pos)

@export var playerID = 1
@onready var area = $Area2D
@onready var castSpr = $cast
@onready var anim = $anim


var stackBlocs := [] 

func set_Up_Blocs(_size:Vector2, _arena:Vector2,_overlord):
	blocSize = _size
	arenaSize.x = _arena.x-1 #due to dont have offset
	arenaSize.y = _arena.y-1
	action.connect(_overlord.selector_Act)
	pass

func _input(event):
	if state != STATE.MOVE: return
	if event.is_action_pressed("ui_right"):
		position.x += blocSize.x 
	elif event.is_action_pressed("ui_left"):
		position.x -= blocSize.x 
	position.x = clamp(position.x,0,arenaSize.x*blocSize.x)
	
	if event.is_action_pressed("ui_up"):
		position.y -= blocSize.y 
	elif  event.is_action_pressed("ui_down"):
		position.y += blocSize.y
	position.y = clamp(position.y,0,arenaSize.y*blocSize.y)
	
	area.position = offset
	castSpr.position = offset
	
	if event.is_action_pressed("P1_Acc"):
		state = STATE.ACTION
		emit_signal("action",self,position)#add stack blocc

func can_Move():
	state = STATE.MOVE
	pass

func disapear_Bloc():
	print(area.get_overlapping_areas())
	area.get_overlapping_areas()[0].queue_free()

func cast():
	anim.play("cast_selec")
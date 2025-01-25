extends Node2D

var textures = [
	preload("res://assets/var1.png"),\
	preload("res://assets/var2.png"),\
	preload("res://assets/var3.png"),\
	preload("res://assets/var4.png")
]
var sudut = [[46,76],[-72,-40],[-30,-1],[0,30]]
const TOLERANCE = 5
var can_take_input = false
var dir = 1
var SPEED = 300
@onready var segitiga = $Segitiga

var player_id : int
var sudut_check 

signal success

func set_up(plyaer_idx):
	visible = true
	var index = randi_range(0,len(textures)-1)
	var temp = textures[index]
	sudut_check = sudut[index]
	$spinny_half_circle.texture = temp
	can_take_input = true
	player_id = plyaer_idx

func _process(delta):
	if can_take_input:
		segitiga.rotation_degrees += SPEED*delta*dir
		if segitiga.rotation_degrees>90:
			dir = -1
		elif segitiga.rotation_degrees<-90:
			dir = 1
		
		if str(player_id) == "1" and GameManager.get_leftp1() and GameManager.get_rightp1() or \
			str(player_id) == "2" and GameManager.get_leftp2() and GameManager.get_rightp2():
			can_take_input = false
			await get_tree().create_timer(0.5).timeout
			can_take_input = true
			if segitiga.rotation_degrees>=sudut_check[0]-TOLERANCE and segitiga.rotation_degrees<=sudut_check[1]+TOLERANCE:
				can_take_input = false
				visible = false
				emit_signal("success")

extends Node2D

var textures = [preload("res://assets/ken1.png"),preload("res://assets/ken2.png"),\
preload("res://assets/ken3.png"),preload("res://assets/ken4.png")]
var sudut = [[-60,-34],[-22,-2],[6,30],[38,65]]
var can_take_input = false
var dir = 1
var SPEED = 70
@onready var segitiga = $Sprite2D

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
		if Input.is_action_just_pressed("leftp"+str(player_id)) and Input.is_action_just_pressed("rightp"+str(player_id)):
			if segitiga.rotation_degrees>=sudut_check[0] and segitiga.rotation_degrees<=sudut_check[1]:
				can_take_input = false
				visible = false
				emit_signal("success")

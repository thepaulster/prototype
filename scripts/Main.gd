extends Node


# game variables
const DINO_START_POS := Vector2(79, 278)
const CAM_START_POS := Vector2(320, 180)
var score : int
var speed : float
const START_SPEED: float = 5.0
const MAX_SPEED: int = 15
var screen_size: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport().size
	print(screen_size)
	new_game()


func new_game():
	#reset variables
	score = 0
	#reset all nodes
	
	$Dino.position = DINO_START_POS
	$Dino.velocity = Vector2(0, 0)
	$Camera2D.position = CAM_START_POS
	$Ground.position = Vector2(0, 0)


func _physics_process(delta):
	speed = START_SPEED
	
	#move dino and camera
	$Dino.position.x += speed
	$Camera2D.position.x += speed
	
	#update score
	score += speed
	
	#update ground position
	#need to change this to spawning different ground sprites
	if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
		$Ground.position.x += screen_size.x
		
	

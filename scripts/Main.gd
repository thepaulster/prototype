extends Node

#preload obstacles
var stump_scene = preload("res://Scenes/Stump.tscn")
var rock_scene = preload("res://Scenes/rock.tscn")
var barrel_scene = preload("res://Scenes/Barrel.tscn")
var bird_scene = preload("res://Scenes/Bird.tscn")
var obstacle_types := [stump_scene, rock_scene,barrel_scene]
var obstacles : Array
var bird_heights := [160, 240]

# game variables
const DINO_START_POS := Vector2(79, 278)
const CAM_START_POS := Vector2(320, 180)
var score : int
const SCORE_MODIFIER : int = 10
var speed : float
const START_SPEED: float = 5.0
const MAX_SPEED: int = 15
const SPEED_MODIFIER : int = 5000
var screen_size: Vector2
var ground_height : int
var game_running : bool
var last_obs #tracks the last spawned obstacle

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport().size
	ground_height = $Ground.get_node("Sprite").texture.get_height()
	print(screen_size)
	new_game()


func new_game():
	randomize()
	
	#reset variables
	score = 0
	show_score()
	game_running = false
	
	#reset all nodes
	
	$Dino.position = DINO_START_POS
	$Dino.velocity = Vector2(0, 0)
	$Camera2D.position = CAM_START_POS
	$Ground.position = Vector2(0, 0)
	
	#reset HUD
	$HUD.get_node("StartLabel").show()


func _physics_process(delta):
	if game_running:
		speed = START_SPEED + score / SPEED_MODIFIER
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		
		#generate obstacles
		generate_obs()
		
		#move dino and camera
		$Dino.position.x += speed
		$Camera2D.position.x += speed
		
		#update score
		score += speed
		show_score()
		
		#update ground position
		#need to change this to spawning different ground sprites
		if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
			$Ground.position.x += screen_size.x
	else:
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			$HUD.get_node("StartLabel").hide()

func generate_obs():
	#generate ground obstacles
	if obstacles.empty() or last_obs.position.x < score + rand_range(100, 300):
		var obs_type = obstacle_types[randi() % obstacle_types.size()]
		var obs
		obs = obs_type.instance()
		var obs_height = obs.get_node("Sprite").texture.get_height()
		var obs_scale = obs.scale
		var obs_x : int = screen_size.x + score + 100
		var obs_y : int = screen_size.y - ground_height - (obs_height * obs_scale.y / 2) + 55
		last_obs = obs
		add_obs(obs, obs_x, obs_y)
	
func add_obs(obs, x, y):
	obs.position = Vector2(x, y)
	add_child(obs)
	obstacles.append(obs)

func show_score():
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score / SCORE_MODIFIER)

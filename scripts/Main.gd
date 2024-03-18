extends Node

#preload ground scenes
var groundScene = preload("res://Scenes/Ground.tscn")

#preload obstacles
var stump_scene = preload("res://Scenes/Stump.tscn")
var rock_scene = preload("res://Scenes/rock.tscn")
var barrel_scene = preload("res://Scenes/Barrel.tscn")
var bird_scene = preload("res://Scenes/Barrel.tscn")#preload("res://Scenes/Bird.tscn")
var bear_scene = preload("res://Scenes/Barrel.tscn")#preload("res://Scenes/Bear.tscn")
var obstacle_types := [stump_scene, rock_scene,barrel_scene]
var obstacles : Array
var bird_heights := [160, 240]
var bear_height := 286

# game variables
const DINO_START_POS := Vector2(79, 278)
const CAM_START_POS := Vector2(320, 180)
var difficulty
const MAX_DIFFICULTY : int = 2
var score : int
const SCORE_MODIFIER : int = 10
var speed : float
const START_SPEED: float = 4.0
const MAX_SPEED: int = 10
const SPEED_MODIFIER : int = 8000
var screen_size: Vector2
var ground_height : int
var game_running : bool
var last_obs #tracks the last spawned obstacle
var groundArray = [] #array to store loaded ground scenes
var visibleGroundCount = 2 #Number of ground scenes visible on the screen
var swapRequested = false #flag to track whether swapping has been initiated

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport().size
	ground_height = $Ground.get_node("Sprite").texture.get_height()
	#print(screen_size)
	#new_game()
	new_ground()


func new_game():
	randomize()
	
	#reset variables
	score = 0
	show_score()
	game_running = false
	difficulty = 0
	
	#reset all nodes
	
	$Dino.position = DINO_START_POS
	$Dino.velocity = Vector2(0, 0)
	$Camera2D.position = CAM_START_POS
	$Ground.position = Vector2(0, 0)
	
	#reset HUD
	$HUD.get_node("StartLabel").show()

func new_ground():
	#load a fixed number of ground scenes into an array
	for i in range(visibleGroundCount):
		var groundInstance = groundScene.instance()
		add_child(groundInstance)
		groundArray.append(groundInstance)
		
		#setip the initial positions of the ground scenes in the array
		arrangeGroundScenes()
		
		#start the initial ground swapping process
		#swapGroundScenes()
		
		Engine.get_main_loop().connect("idle_frame", self, "swapGroundScenes")

func _physics_process(delta):
	if game_running:
		#speed up and adjust difficulty
		speed = START_SPEED + score / SPEED_MODIFIER
		if speed > MAX_SPEED:
			speed = MAX_SPEED
			
		adjust_difficulty()
		
		#generate obstacles
		generate_obs()
		
		#move dino and camera
		$Dino.position.x += speed
		$Camera2D.position.x += speed
		
		##print(randi() % 5)
		#update score
		score += speed
		show_score()
		
		#update ground position
		#need to change this to spawning different ground sprites
		if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
			#$Ground.position.x += screen_size.x
			#swapGroundScenes()
			#requestGroundSwap()
			pass
		
		#remove obstacles that have gone off screen
		for obs in obstacles:
			if obs.position.x < ($Camera2D.position.x - screen_size.x):
				remove_obs(obs)
		
	else:
		if Input.is_action_pressed("ui_accept") or InputEventScreenTouch:
			game_running = true
			$HUD.get_node("StartLabel").hide()

func _process(delta):
	requestGroundSwap()

func generate_obs():
	#generate ground obstacles
	if obstacles.empty() or last_obs.position.x < score + rand_range(100, 300):
		var obs_type = obstacle_types[randi() % obstacle_types.size()]
		var obs
		var max_obs = difficulty + 1 
		for i in range(randi() % max_obs + 1):
			obs = obs_type.instance()
			var obs_height = obs.get_node("Sprite").texture.get_height()
			var obs_scale = obs.scale
			var obs_x : int = screen_size.x + score + 100 + (i * 30)
			var obs_y : int = screen_size.y - ground_height - (obs_height * obs_scale.y / 2) + 55
			last_obs = obs
			add_obs(obs, obs_x, obs_y)
		#additionally random chance to spawn a bird
		if difficulty == 0: #MAX_DIFFICULTY:
			if (randi() % 2) == 0:
				#generate bird obstacles
				obs = bird_scene.instance()
				var obs_x : int = screen_size.x + score + 100
				var obs_y : int = bird_heights[randi() % bird_heights.size()]
				add_obs(obs, obs_x, obs_y)
				
			elif (randi() % 3) == 1:
				#generate enemy
				obs = bear_scene.instance()
				var obs_x : int = screen_size.x + score + 100
				var obs_y : int = bear_height
				add_obs(obs, obs_x, obs_y)
				
				pass
		

func add_obs(obs, x, y):
	obs.position = Vector2(x, y)
	add_child(obs)
	obstacles.append(obs)

func remove_obs(obs):
	obs.queue_free()
	obstacles.erase(obs)

func show_score():
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score / SCORE_MODIFIER)


func adjust_difficulty():
	difficulty = score / SPEED_MODIFIER
	if difficulty > MAX_DIFFICULTY:
		difficulty = MAX_DIFFICULTY

func arrangeGroundScenes():
	#set the positions of ground scenes based on their order in the array
	for i in range(groundArray.size()):
		groundArray[i].position = Vector2(i * groundScene.instance().get_child(3).texture.get_width(), 0)
	

func requestGroundSwap():
	swapRequested = true

func swapGroundScenes():
	if swapRequested:
		print("test")
		#move the first ground scene to the end of the arrray
		var firstGround =  groundArray[0]
		groundArray.remove(0)
		groundArray.append(firstGround)
		
		#adjust the positions of ground scenes
		arrangeGroundScenes()
		
		#Check if the first groundscene is completely off the screen
		if firstGround.position.x + firstGround.get_child(3).texture.get_width() < 0:
			
			#remove the ground instance from both the scene and the array
			firstGround.queue_free()
			groundArray.remove(0) 
		
		#spawn a new ground at the end of the array
		var lastGround = groundArray[groundArray.size() - 1]
		var newGround = groundScene.instance()
		newGround.position = lastGround.position + Vector2(lastGround.get_child(3).texture.get_width(), 0)
		add_child(newGround)
		groundArray.append(newGround)
		
		swapRequested = false

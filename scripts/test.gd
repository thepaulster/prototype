extends Node2D


#preload obstacles
var stump_scene = preload("res://Scenes/Stump.tscn")
var rock_scene = preload("res://Scenes/rock.tscn")
var barrel_scene = preload("res://Scenes/Barrel.tscn")
var bird_scene = preload("res://Scenes/Bird.tscn")
var bear_scene = preload("res://Scenes/Bear.tscn")
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
const START_SPEED: float = 5.0
const MAX_SPEED: int = 12
const SPEED_MODIFIER : int = 8000
var screen_size: Vector2
var ground_height : int
var game_running : bool
var last_obs #tracks the last spawned obstacle

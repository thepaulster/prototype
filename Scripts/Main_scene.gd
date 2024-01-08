extends Node2D
#new
var obstacleScene = preload("res://Ground/Obstacle.tscn")

var groundScene = preload("res://Ground/Ground.tscn")
var groundArray = []
#var groundArrayIdex = 0
var screenWidth = 800

var index

func _ready():
	randomize()
	spawnInitialGround()
	
	
	pass


func spawnInitialGround():
	#Spawn the initial ground sprite at the starting position
	var initialGround = groundScene.instance()
	call_deferred("add_child", initialGround)
	groundArray.append(initialGround)
	

func spawnNewGroundAtEnd():
	var lastGround = groundArray[groundArray.size() - 1]
	
	var lastGroundpostion = lastGround.position
	
	var newGroundPosition = lastGroundpostion + Vector2(lastGround.get_child(0).texture.get_width(), 0)
	
	#print(newGroundPosition)
	
	var newGround = groundScene.instance()
	
	newGround.position = newGroundPosition
	
	call_deferred("add_child", newGround)
	
	groundArray.append(newGround)
	
	obstacleSpawn(newGround)

func _process(_delta):
	movingGround()
	pass

func movingGround():
	
	var firstGround = groundArray[0]
	var firstGroundPosition = firstGround.position
	
	if firstGroundPosition.x + firstGround.get_child(0).texture.get_width() < 0:
		firstGround.queue_free()
		groundArray.remove(0)
	
	var lastGround = groundArray[groundArray.size() - 1]
	
	if lastGround.position.x + lastGround.get_child(0).texture.get_width() < get_viewport_rect().size.x:
		spawnNewGroundAtEnd()


func obstacleSpawn(lastGround):
	var spawnPosition = Vector2(rand_range(0, lastGround.get_child(0).texture.get_width()), lastGround.get_child(0).position.y - rand_range(0, lastGround.get_child(0).texture.get_height()))
	var initialObstacle = obstacleScene.instance()
	
	if spawnPosition.x == 0:
		spawnPosition.x += initialObstacle.get_child(0).texture.get_width()
		
	elif spawnPosition.x >= lastGround.get_child(0).texture.get_width():
		spawnPosition.x -= initialObstacle.get_child(0).texture.get_width()
	
	initialObstacle.position = spawnPosition
	
	call_deferred("add_child", initialObstacle)
	
	print(spawnPosition)
	#var newObstaclePosition = Vector2(rand_range(lastGround.get_child(0).texture.get_width()-initialObstacle))
	pass

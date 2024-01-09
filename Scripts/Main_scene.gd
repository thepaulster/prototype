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
	
	#movingGround()
	pass

func spawnInitialGround():
	#Spawn the initial ground sprite at the starting position
	var initialGround = groundScene.instance()
	
	initialGround.position = Vector2(0,0)
	
	call_deferred("add_child", initialGround)
	
	groundArray.append(initialGround)
	

func spawnNewGroundAtEnd():
	var lastGround = groundArray[groundArray.size() - 1]
	
	var lastGroundPosition = lastGround.position
	
	var newGroundPosition = lastGroundPosition + Vector2(lastGround.get_child(0).texture.get_width(), 0)
	
	#print(lastGroundPosition)
	#print(newGroundPosition)
	
	var newGround = groundScene.instance()
	
	newGround.position = newGroundPosition
	
	call_deferred("add_child", newGround)
	
	groundArray.append(newGround)
	
	obstacleSpawn(newGround, lastGround)
	
	#print("spawned")
	

func _process(_delta):
	#print(get_viewport_transform().get_origin().x)
	movingGround()
	pass

func movingGround():
	
	var firstGround = groundArray[0]
	var firstGroundPosition = firstGround.position
	
	if firstGroundPosition.x + firstGround.get_child(0).texture.get_width() < -get_viewport_transform().get_origin().x:
		#print("works")
		firstGround.queue_free()
		groundArray.remove(0)
	
	var lastGround = groundArray[groundArray.size() - 1]
	var lastGroundPosition = lastGround.position
	#print(-get_viewport_transform().get_origin().x)
	
	#if lastGroundPosition.x + lastGround.get_child(0).texture.get_width() < get_viewport_rect().size.x:
	if lastGroundPosition.x  <= -get_viewport_transform().get_origin().x + 600 :
		#print(lastGroundPosition.x)
		#print(-get_viewport_transform().get_origin().x)
		
		spawnNewGroundAtEnd()

func obstacleSpawn(groundPosition, lstGround):
	var spawnPosition = Vector2(rand_range(lstGround.position.x + lstGround.get_child(0).texture.get_width(), groundPosition.position.x) + lstGround.get_child(0).texture.get_width(), groundPosition.get_child(0).position.y - rand_range(0, groundPosition.get_child(0).texture.get_height()))
	var initialObstacle = obstacleScene.instance()
	
	if spawnPosition.x == lstGround.position.x:
		spawnPosition.x += initialObstacle.get_child(0).texture.get_width()
		
	elif spawnPosition.x >= groundPosition.get_child(0).texture.get_width():
		spawnPosition.x -= initialObstacle.get_child(0).texture.get_width()
	
	initialObstacle.position = spawnPosition
	
	call_deferred("add_child", initialObstacle)
	
	#print(spawnPosition)
	#var newObstaclePosition = Vector2(rand_range(lastGround.get_child(0).texture.get_width()-initialObstacle))
	pass

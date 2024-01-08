extends Node2D
#new
var groundScene = preload("res://Ground/Ground.tscn")
var groundArray = []
#var groundArrayIdex = 0
var screenWidth = 800

var index

func _ready():
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
	
	var newGround = groundScene.instance()
	
	newGround.position = newGroundPosition
	
	call_deferred("add_child", newGround)
	
	groundArray.append(newGround)

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

extends KinematicBody2D

const playerGravity = 200 
var velocity = Vector2()
var playerRunSpeed= 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	velocity.y += delta * playerGravity
	
	velocity.x = playerRunSpeed
	
	move_and_slide(velocity)
	pass


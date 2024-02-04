extends KinematicBody2D

const GRAVITY : int = 2200 #force pulling player down
const JUMP_SPEED : int = -900 #force to jump up

var velocity : Vector2 = Vector2()

func _physics_process(delta):
	
	velocity.y += GRAVITY * delta 
	if Input.is_action_pressed("ui_accept"):
		velocity.y = JUMP_SPEED
	
	move_and_slide(velocity)

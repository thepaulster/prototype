extends KinematicBody2D

const GRAVITY : int = 2200 #force pulling player down
const JUMP_SPEED : int = -900 #force to jump up
const JUMP = Vector2(0, 1)

var velocity : Vector2 = Vector2()

func _ready():
	$AnimatedSprite.play("idle")

func _physics_process(delta):
	
	velocity.y += GRAVITY * delta 
	if is_on_floor():
		if not get_parent().game_running:
			$AnimatedSprite.play("idle")
		else:
			$RunCol.disabled = false
			if Input.is_action_pressed("ui_accept"):
				velocity.y = JUMP_SPEED
			elif Input.is_action_pressed("ui_down"):
				$AnimatedSprite.play("duck")
			else:
				$AnimatedSprite.play("run")
	else:
		$AnimatedSprite.play("jump")
	
	velocity.y = move_and_slide(velocity, Vector2.UP).y
	

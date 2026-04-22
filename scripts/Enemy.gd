extends CharacterBody2D

const UP = Vector2(0, -1)

@export var speed: int = -400
@export var gravity: int = 1200


func _process(_delta):
	if position.y >= 600:
		queue_free()


func _physics_process(delta):
	velocity.y += delta * gravity
	velocity.x = speed
	set_velocity(velocity)
	set_up_direction(UP)
	move_and_slide()
	velocity = velocity

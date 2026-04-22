extends CharacterBody2D

const UP = Vector2(0, -1)

@export var speed: int = 400
@export var gravity: int = 1400
@export var jump_speed: int = -600

@onready var animator = self.get_node("Animator")
@onready var sprite = self.get_node("Sprite2D")


func get_input():
	velocity.x = 0
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed
	if Input.is_action_pressed("right"):
		sprite.flip_h = false
		velocity.x += speed
	elif Input.is_action_pressed("left"):
		sprite.flip_h = true
		velocity.x -= speed


func _physics_process(delta):
	velocity.y += delta * gravity
	get_input()
	set_velocity(velocity)
	set_up_direction(UP)
	move_and_slide()
	velocity = velocity


func _process(_delta):
	if velocity.y != 0:
		animator.play("Jump")
	elif velocity.x != 0:
		animator.play("Walk")
	else:
		animator.play("Idle")

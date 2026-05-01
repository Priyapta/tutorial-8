extends CharacterBody2D

const UP = Vector2(0, -1)
const ACCELERATION = 400.0
const DECELERATION = 400.0

@export var speed: float = 400.0
@export var gravity: int = 1400
@export var jump_speed: int = -600
@export var max_lives: int = 3

@onready var animator = self.get_node("Animator")
@onready var sprite = self.get_node("Sprite2D")
@onready var particle = $GPUParticles2D
@onready var camera = $Camera2D
@onready var base_scale = sprite.scale

var lives: int = 3
var start_position := Vector2.ZERO
var _was_on_floor: bool = false
var invincible: bool = false
var invincible_timer: float = 0.0

signal lives_changed(new_lives: int)

func _ready():
	lives = max_lives
	start_position = position
	add_to_group("player")

func get_input():
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed
		squash_and_stretch(base_scale * Vector2(0.8, 1.3), 0.1)
	if Input.is_action_pressed("right"):
		sprite.flip_h = false
		velocity.x = lerp(velocity.x, speed, ACCELERATION / speed)
	elif Input.is_action_pressed("left"):
		sprite.flip_h = true
		velocity.x = lerp(velocity.x, -speed, ACCELERATION / speed)
	else:
		velocity.x = lerp(velocity.x, 0.0, DECELERATION / speed)

func _physics_process(delta):
	velocity.y += delta * gravity
	get_input()
	set_particles()
	var fall_speed = velocity.y
	set_velocity(velocity)
	set_up_direction(UP)
	move_and_slide()
	velocity = velocity

	if is_on_floor() and not _was_on_floor:
		squash_and_stretch(base_scale * Vector2(1.3, 0.7), 0.15)
		if fall_speed > 400:
			screen_shake(3.0, 0.15)
	_was_on_floor = is_on_floor()

	if invincible:
		invincible_timer -= delta
		sprite.visible = int(invincible_timer * 10) % 2 == 0
		if invincible_timer <= 0:
			invincible = false
			sprite.visible = true

	if position.y > 600:
		if invincible:
			position = start_position
			velocity = Vector2.ZERO
		else:
			take_damage()

func set_particles():
	if abs(velocity.x) == speed and is_on_floor():
		particle.set_emitting(true)
	else:
		particle.set_emitting(false)

func _process(_delta):
	if velocity.y != 0:
		animator.play("Jump")
	elif velocity.x != 0:
		animator.play("Walk")
	else:
		animator.play("Idle")

func squash_and_stretch(target_scale: Vector2, duration: float):
	var tween = create_tween()
	tween.tween_property(sprite, "scale", target_scale, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "scale", base_scale, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func screen_shake(intensity: float, duration: float):
	var tween = create_tween()
	var steps = int(duration * 40)
	for i in range(steps):
		var shake_offset = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		tween.tween_property(camera, "offset", shake_offset, duration / steps)
	tween.tween_property(camera, "offset", Vector2.ZERO, 0.05)

func take_damage():
	if invincible:
		return
	lives -= 1
	emit_signal("lives_changed", lives)
	screen_shake(5.0, 0.2)
	if lives <= 0:
		get_tree().reload_current_scene.call_deferred()
	else:
		invincible = true
		invincible_timer = 1.5
		position = start_position
		velocity = Vector2.ZERO

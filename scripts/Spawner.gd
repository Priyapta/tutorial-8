extends Node2D

@export var spawn_rate: float = 0.3

var current_time = 0

@onready var enemy = preload("res://Scenes/Enemy.tscn")


func _ready():
	current_time = spawn_rate


func _process(delta):
	current_time -= delta
	if current_time <= 0:
		current_time = spawn_rate
		var new_enemy = enemy.instantiate()
		add_child(new_enemy)

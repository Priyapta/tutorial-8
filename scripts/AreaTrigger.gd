extends Area2D

@export var scene_name: String = "Level 1"


func _on_area_trigger_body_entered(body):
	if body.get_name() == "Player":
		get_tree().change_scene_to_file(str("res://scenes/" + scene_name + ".tscn"))

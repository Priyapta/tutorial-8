extends CanvasLayer

var lives_label: Label

func _ready():
	lives_label = Label.new()
	lives_label.text = "Lives: 3"
	lives_label.position = Vector2(20, 20)
	lives_label.add_theme_font_size_override("font_size", 32)
	lives_label.add_theme_color_override("font_outline_color", Color.BLACK)
	lives_label.add_theme_constant_override("outline_size", 3)
	add_child(lives_label)

	await get_tree().process_frame
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var player = players[0]
		update_lives_display(player.lives)
		player.lives_changed.connect(update_lives_display)

func update_lives_display(new_lives: int):
	lives_label.text = "Lives: " + str(new_lives)
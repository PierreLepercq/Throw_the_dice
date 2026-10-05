extends Area3D
const FILE_DIR = "res://Levels/level_"

@export var three_stars = 0 
@export var two_stars = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and body.green == "top" and not body.finished:
		body.finished = true   # stop the dice
		var current_scene_file = get_tree().current_scene.scene_file_path
		var next_level_number = current_scene_file.to_int() + 1
		var next_level_path = FILE_DIR + str(next_level_number) + ".tscn"
		if not ResourceLoader.exists(next_level_path):
			next_level_path = "res://Levels/Main menu.tscn"
		body.show_win(count_stars(body.moves), three_stars, two_stars, next_level_path)

func count_stars(moves: int) -> int:
	if moves <= three_stars:
		return 3
	elif moves <= two_stars:
		return 2
	return 1

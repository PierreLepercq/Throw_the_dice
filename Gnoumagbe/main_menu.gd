extends Control

func play():
	get_tree().change_scene_to_file('res://Levels/level_0.tscn')

func exit():
	get_tree().quit()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Play.pressed.connect(play)
	%Exit.pressed.connect(exit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends Control

var first_level = preload("res://Levels/level_0.tscn") #pour eviter trop d'attente sur le menu

func play():
	%Play.text = "Loading..."
	%Play.disabled = true
	await get_tree().process_frame
	await get_tree().process_frame
	get_tree().change_scene_to_packed(first_level)

func exit():
	get_tree().quit()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Play.pressed.connect(play)
	%Exit.visible = not OS.has_feature("web")
	%Exit.pressed.connect(exit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

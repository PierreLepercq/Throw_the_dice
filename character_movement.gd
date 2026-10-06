extends RigidBody3D

@onready var ray: RayCast3D = $RayCast3D
@onready var pivot = $Pivot
@onready var mesh = $Pivot/Mesh
@onready var audio_players: Array[AudioStreamPlayer] = [$AudioStreamPlayer1, $AudioStreamPlayer2]
@onready var rolling_audio = $RollingAudioPlayer # Le nouveau lecteur pour le roulement

@export var sons_de: Array[AudioStream] = []

var dice_img = preload("res://assets/2d/dice.png")
var moves = 0

var cube_size = 1.0
var speed = 4.0
var rolling = false
var green = "top" 
var finished = false
var is_on_platform = false

var next_level_path = ""

func _ready() -> void:
	update_moves_label()
	$HUD/PanelContainer/WinPanel/Next.pressed.connect(_on_next_pressed)
	$HUD/PanelContainer/WinPanel/Retry.pressed.connect(_on_retry_pressed)
	
func _physics_process(delta: float) -> void:
	if finished:
		return
		
	if transform.origin.y < -10.0:
		var current_scene_file = get_tree().current_scene.scene_file_path
		get_tree().call_deferred("change_scene_to_file", current_scene_file)
		return
		
	var query = PhysicsRayQueryParameters3D.create(
		global_position + Vector3.UP * 0.5,
		global_position + Vector3.DOWN * 1.0
	)
	query.exclude = [get_rid()]  # ignore le cube lui-même
	if get_world_3d().direct_space_state.intersect_ray(query).is_empty():
		return

	# Détecte si le joueur appuie sur une touche de mouvement
	var is_moving_input = Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left")
	
	# Gère le son de roulement continu
	#if is_moving_input and not rolling_audio.playing:
	#	rolling_audio.play()
	#elif not is_moving_input and rolling_audio.playing:
	#	rolling_audio.stop()

	var forward = Vector3.FORWARD
	if Input.is_action_pressed("ui_up"):
		roll(forward, "up")
	if Input.is_action_pressed("ui_down"):
		roll(-forward, "down")
	if Input.is_action_pressed("ui_right"):
		roll(forward.cross(Vector3.UP), "right")
	if Input.is_action_pressed("ui_left"):
		roll(-forward.cross(Vector3.UP), "left")

func roll(dir, direction_name) -> void:
	if rolling:
		return
	rolling = true

	# Joue la note de musique uniquement si le son de roulement ne prend pas le relais
	if not sons_de.is_empty():# and not rolling_audio.playing:
		var audio_player = audio_players[moves % 2]
		audio_player.stream = sons_de.pick_random()
		audio_player.play()

	pivot.translate(dir * cube_size / 2)
	mesh.global_translate(-dir * cube_size / 2)

	var axis = dir.cross(Vector3.DOWN)
	var tween = create_tween()
	tween.tween_property(pivot, "transform",
		pivot.transform.rotated_local(axis, PI/2), 1 / speed)
	await tween.finished

	green = DiceRoll.green_pos(green, direction_name)

	transform.origin += dir * cube_size
	var b = mesh.global_transform.basis
	pivot.transform = Transform3D.IDENTITY
	mesh.position = Vector3(0, cube_size / 2, 0)
	mesh.global_transform.basis = b
	rolling = false
	moves += 1
	update_moves_label()
	
func update_moves_label() -> void:
	$HUD/Moves.text = "Moves: " + str(moves)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _unhandled_input(event: InputEvent) -> void: # pour restart avec R
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_R:
			get_tree().reload_current_scene()
		if event.keycode == KEY_L:
			get_tree().change_scene_to_file("res://level_select.tscn")

func show_win(stars: int, three_stars: int, two_stars: int, next_path: String) -> void:
	var help = get_tree().current_scene.get_node_or_null("Help")
	if help:
		help.visible = false
	$HUD/Moves.visible = false
	$HUD/Restart.visible = false
	$HUD/Load.visible = false
	next_level_path = next_path
	$HUD/PanelContainer/WinPanel/WinText.text = "Level complete!\n"
	$HUD/PanelContainer/WinPanel/FinalMoves.text = "Your moves: " + str(moves) + "\n"
	if (stars < 2):
		$HUD/PanelContainer/WinPanel/TwoStars.text = "2 stars: " + str(two_stars) + " moves\n"
	if (stars < 3):
		$HUD/PanelContainer/WinPanel/ThreeStars.text = "3 stars: " + str(three_stars) + " moves\n"
	var dice_slots = $HUD/PanelContainer/WinPanel/Dice.get_children()
	for i in range(dice_slots.size()):
		if (i >= stars):
			dice_slots[i].modulate = Color(0.5, 0.5, 0.5, 0.5)
	if next_path.ends_with("Main menu.tscn"):
		$HUD/PanelContainer/WinPanel/Next.text = "Back to menu"   # last level

	$HUD/PanelContainer.visible = true
	$HUD/PanelContainer/WinPanel/Next.grab_focus()   # so Enter/Space also presses "Next level"

func _on_next_pressed() -> void:
	get_tree().change_scene_to_file(next_level_path)

func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()

extends RigidBody3D

@onready var pivot = $Pivot
@onready var mesh = $Pivot/Mesh
@onready var audio_player = $AudioStreamPlayer
@onready var rolling_audio = $RollingAudioPlayer # Le nouveau lecteur pour le roulement

@export var sons_de: Array[AudioStream] = []

var moves = 0

var cube_size = 1.0
var speed = 4.0
var rolling = false
var green = "top" 

func _ready() -> void:
	update_moves_label()

func _physics_process(delta: float) -> void:
	
	# Détecte si le joueur appuie sur une touche de mouvement
	var is_moving_input = Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left")
	
	# Gère le son de roulement continu
	if is_moving_input and not rolling_audio.playing:
		rolling_audio.play()
	elif not is_moving_input and rolling_audio.playing:
		rolling_audio.stop()

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
	if not sons_de.is_empty() and not rolling_audio.playing:
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
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_R:
		get_tree().reload_current_scene()

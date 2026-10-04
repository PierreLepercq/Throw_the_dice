extends RigidBody3D
@onready var pivot = $Pivot
@onready var mesh = $Pivot/Mesh
@onready var audio_player = $AudioStreamPlayer


@export var sons_de: Array[AudioStream] = []

var cube_size = 1.0
var speed = 4.0
var rolling = false
var green = "top" 

func _physics_process(delta: float) -> void:
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

	if not sons_de.is_empty():
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

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass

extends Camera3D

@export var distance = 4.0
@export var height = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends Camera3D
@export var player: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player:
		look_at(player.global_position, Vector3.UP)

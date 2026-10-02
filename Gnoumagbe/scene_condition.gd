extends Node3D
@export var player: Node3D
#Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.global_position = self.global_position;
#Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends Control

func _ready() -> void:
	%Niveau0.pressed.connect(func(): get_tree().change_scene_to_file("res://Levels/level_0.tscn"))
	%Niveau1.pressed.connect(func(): get_tree().change_scene_to_file("res://Levels/level_1.tscn"))
	%Niveau2.pressed.connect(func(): get_tree().change_scene_to_file("res://Levels/level_2.tscn"))
	%Niveau3.pressed.connect(func(): get_tree().change_scene_to_file("res://Levels/level_3.tscn"))
	%Back.pressed.connect(func(): get_tree().change_scene_to_file("res://Levels/Main menu.tscn"))
	

@tool
class_name DiceRoll

static func green_pos(green: String, direction: String) -> String:
	if direction == "up":       # towards -Z
		match green:
			"top": return "north"
			"north": return "bottom"
			"bottom": return "south"
			"south": return "top"
	elif direction == "down":   # towards +Z
		match green:
			"top": return "south"
			"south": return "bottom"
			"bottom": return "north"
			"north": return "top"
	elif direction == "right":  # towards +X
		match green:
			"top": return "east"
			"east": return "bottom"
			"bottom": return "west"
			"west": return "top"
	elif direction == "left":   # towards -X
		match green:
			"top": return "west"
			"west": return "bottom"
			"bottom": return "east"
			"east": return "top"
	return green

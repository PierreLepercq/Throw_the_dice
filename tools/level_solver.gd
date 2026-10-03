@tool
extends Node

@export var grid: GridMap
@export var start: Node3D
@export var goal: Node3D

@export_enum("top", "bottom", "north", "south", "east", "west")

var green_at_start: String = "top"

@export_tool_button("Solve level") var solve_button = solve

const MOVES = {
	"up": Vector2i(0, -1),
	"down": Vector2i(0, 1),
	"right": Vector2i(1, 0),
	"left": Vector2i(-1, 0),
}

func has_tile(cell: Vector2i) -> bool:
	return grid.get_cell_item(Vector3i(cell.x, 0, cell.y)) != GridMap.INVALID_CELL_ITEM

func cell_of(node: Node3D) -> Vector2i:
	var map_position = grid.local_to_map(grid.to_local(node.global_position))
	return Vector2i(map_position.x, map_position.z)

# to solve, we try every possible move.
# We add "situation": where the dice is + where the green face is.
# We never look at the same situation twice, otherwise we would loop forever.
func solve() -> void:
	if grid == null or start == null or goal == null:
		print("Solver: drag the GridMap, Start and End nodes into the Inspector first.")
		return
	var start_cell = cell_of(start)
	var goal_cell = cell_of(goal)
	if not has_tile(start_cell):
		print("Solver: the start is not on a tile.")
		return
	if not has_tile(goal_cell):
		print("Solver: the goal is not on a tile.")
		return
		
	var queue = []
	queue.append({"cell": start_cell, "green": green_at_start, "moves": []})
	var reached = {}
	reached[str(start_cell.x) + "," + str(start_cell.y) + "," + green_at_start] = true

	while queue.size() > 0:
		var current = queue.pop_front()
		if current.cell == goal_cell and current.green == "top":
			print_solution(current.moves)
			return
		for direction in MOVES:
			var next_cell = current.cell + MOVES[direction]
			if not has_tile(next_cell):
				continue
			var next_green = DiceRoll.green_pos(current.green, direction)
			var id = str(next_cell.x) + "," + str(next_cell.y) + "," + next_green
			if reached.has(id):
				continue
			reached[id] = true
			var next_moves = current.moves.duplicate()
			next_moves.append(direction)
			queue.append({"cell": next_cell, "green": next_green, "moves": next_moves})

	print("Solver: IMPOSSIBLE.")
	print("        (Looked at ", reached.size(), " situations.)")


func print_solution(moves: Array) -> void:
	var text = ""
	for move in moves:
		text += move + " "
	print("Solver: solvable in ", moves.size(), " moves (shortest).")
	print("        ", text)

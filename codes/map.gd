extends Node
class_name Map

var HEIGHT:int
var WIDTH:int
var cellScene: PackedScene
var cellArray: Array
var cellSize: float
var mapOffset: Vector2

func init(height: int, width: int, _cellScene: PackedScene, _cellSize: float) -> void:
	HEIGHT = height
	WIDTH = width
	cellScene = _cellScene
	cellSize = _cellSize
	cellArray.clear()

func createMap() -> void:
	_fillCellArray()
	_addCellsToTheScene()
	fillAllNeighbour()

func getCellSize() -> float:
	var cell = cellArray.front() as Cell
	return cell.getTextureSize()

func _fillCellArray():
	for y in HEIGHT:
		for x in WIDTH:
			cellArray.append(_createCellObject(Vector2(x,y)))
			
func _createCellObject(pos: Vector2i):
	var cell = cellScene.instantiate()
	var cellScript:Cell =  cell as Cell
	cellScript.setTextureSize(cellSize)
	cellScript.setMapPosition(pos)
	cellScript.setMaxFandH()
	return cell

func _addCellsToTheScene():
	if cellArray.is_empty():
		printerr("Cell array is empty. Can not added to the scene.")
		return
	var parentOfCells = Node2D.new()
	parentOfCells.name = "ParentOfCells"
	var screenSize : Vector2i = DisplayServer.window_get_size()
	var mapSizeInPixel : Vector2i = Vector2i(WIDTH, HEIGHT) * cellSize
	parentOfCells.position = Vector2(screenSize - mapSizeInPixel) / 2
	mapOffset = parentOfCells.position
	add_child(parentOfCells)
	for cell in cellArray:
		parentOfCells.add_child(cell)

func fillAllNeighbour():
	for cell in cellArray:
		fillNeighbourTo(cell as Cell)

func fillNeighbourTo(cell: Cell):
	var neigbourArray: Array[Cell]
	var degree = 0
	var dir = Vector2.RIGHT
	while degree != 360:
		var _dir = dir.rotated(deg_to_rad(degree))
		_dir.x = roundi(_dir.x)
		_dir.y = roundi(_dir.y)
		var neighbour = _getCell(Vector2(cell.getMapPosition()) + _dir)
		if neighbour != null:
			neigbourArray.append(neighbour as Cell)
		degree += 45
	cell.setNeighbours(neigbourArray)
																								   
func selectCell(pos: Vector2i, color: Color) -> Cell:
	var cell = _getCell(pos)
	var cellScript: Cell = cell as Cell
	cellScript.setColor(color)
	return cellScript

func _getCell(pos: Vector2i):
	if pos.x < 0 or pos.x >= WIDTH or pos.y < 0 or pos.y >= HEIGHT: return
	var index = pos.x + pos.y * WIDTH
	if index < 0 or index >= cellArray.size(): return
	var cell = cellArray[index]
	if cell:
		return cell
	print_debug("Can not return cell!")

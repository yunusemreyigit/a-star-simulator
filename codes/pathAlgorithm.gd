class_name AStar

var _openList: Array
var _closedList: Array
var start: Cell
var goal: Cell
var _isFound: bool

var timer: Timer
var walls: Array

var pathColor: Color
var visitedColor: Color
var neighbourColor: Color
var isTextVisible: bool
var isExecutionCompleted: bool = true

func _init(_start: Cell, _goal:Cell, extraClosed:Array, timer: Timer, settings: SimSettings) -> void:
	start = _start
	goal = _goal
	_closedList.append_array(extraClosed)
	pathColor = settings.colorSettings.pathColor
	visitedColor = settings.colorSettings.visitedColor
	walls = extraClosed
	neighbourColor = settings.colorSettings.neighbourColor
	isTextVisible = settings.isTextVisible
	self.timer = timer

func execute():
	if(!start or !goal):
		print_debug("Start or Goal Cell is not defined!")
		return
	start.g = 0
	_openList.append(start)
	algorithm()
	
func algorithm():
	setIsExecutionCompleted(false)
	while !_isFound:
		var currentTile = getTileWhichFisLeastFromOpenList()
		_closedList.append(currentTile)
		
		await  timer.timeout
		
		if currentTile == goal or currentTile == null:
			break;
		
		if currentTile != start:
			currentTile.setColor(visitedColor)
		
		for wall: Cell in currentTile.neighbours:
			if wall in walls:
				extractTilesNextToWall(currentTile, wall)
		
		for neighbour:Cell in currentTile.neighbours:	
			if neighbour in _closedList or neighbour == null:
				continue
			var g = currentTile.g + distanceFromPrev(neighbour, currentTile)
			if g < neighbour.g:
				neighbour.g = g
			else:
				continue
			var h = manhattanDistance(goal, neighbour)
			neighbour.h = h
			neighbour.f = g + h
			await timer.timeout
			neighbour.setPreviousCell(currentTile)
			neighbour.setColor(neighbourColor)
			neighbour.updateTexts()
			if isTextVisible:
				neighbour.showText()
			if neighbour == goal: _isFound = true;
			_openList.append(neighbour)
		_openList.erase(currentTile)
	drawPath()
	setIsExecutionCompleted(true)

func drawPath():
	var tile = goal
	while tile:
		tile.setColor(pathColor)
		tile = tile.getPreviousCell()
		
func distance(NodeA: Cell, NodeB: Cell)->float:
	return (NodeA.getMapPosition() - NodeB.getMapPosition()).length()

func distanceFromPrev(NodeA: Cell, NodeB: Cell) -> float:
	return distance(NodeA,NodeB) * 10
	
func manhattanDistance(NodeA: Cell, NodeB: Cell) -> float:
	var diffX = abs(NodeA.getMapPosition().x - NodeB.getMapPosition().x)
	var diffY = abs(NodeA.getMapPosition().y - NodeB.getMapPosition().y)
	return (diffX + diffY) * 10

func getTileWhichFisLeastFromOpenList() -> Cell:
	var min: Cell = _openList.front()
	for tile in _openList:
		if tile.f < min.f:
			min = tile
	return min

func extractTilesNextToWall(centralCell: Cell, wall: Cell):
	var direction: Vector2i = (wall.getMapPosition() - centralCell.getMapPosition());
	if direction == Vector2i.RIGHT:
		centralCell.extractNeighbour(Vector2(1, -1))
		centralCell.extractNeighbour(Vector2(1, 1))
	if direction == Vector2i.LEFT:
		centralCell.extractNeighbour(Vector2(-1, -1))
		centralCell.extractNeighbour(Vector2(-1, 1))
	if direction == Vector2i.UP:
		centralCell.extractNeighbour(Vector2(1, -1))
		centralCell.extractNeighbour(Vector2(-1, -1))
	if direction == Vector2i.DOWN:
		centralCell.extractNeighbour(Vector2(1, 1))
		centralCell.extractNeighbour(Vector2(-1, 1))

func setIsExecutionCompleted(value: bool):
	isExecutionCompleted = value

func getIsExecutionCompleted() -> bool:
	return isExecutionCompleted
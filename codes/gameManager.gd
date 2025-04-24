extends Node2D
class_name GameManager

var isInitTileSelected: bool
var isTargetTileSelected: bool

@export var settings: SimSettings
@export var timer: Timer
@export var speed: float = 2

var map: Map
var inputHandler: InputHandler
var startCell: Cell
var goalCell: Cell
var walls: Array
var parentOfCells
var mapOffset: Vector2

var height
var width
var cellScene = preload("res://scenes/cell.tscn")

var algorithm: AStar

func _ready() -> void:
	makeMap()

func _process(delta: float) -> void:
	while parentOfCells == null:
		parentOfCells = $"../Map".get_child(0)

	if parentOfCells != null:
		mapOffset = parentOfCells.position
	else:
		mapOffset = Vector2.ZERO

	if Input.is_action_just_pressed("click"):
		selectTargetTile()
		selectInitTile()
	
	if startCell and goalCell:
		if getAlgorithm().getIsExecutionCompleted() == true:	
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
				if inputHandler.getMousePos(get_global_mouse_position(), mapOffset) >= Vector2i.ZERO:
					var pos = inputHandler.getMousePos(get_global_mouse_position(), mapOffset)
					if pos != startCell.getMapPosition() and pos != goalCell.getMapPosition():
						var tile = map.selectCell(pos, settings.colorSettings.wallColor)
						if walls.has(tile) == false:
							walls.append(tile)
	if parentOfCells:
		if Input.is_action_pressed("ui_left"):
			parentOfCells.position = parentOfCells.position + (Vector2.RIGHT * speed) * delta
		if Input.is_action_pressed("ui_down"):
			parentOfCells.position = parentOfCells.position + (Vector2.UP * speed) * delta
		if Input.is_action_pressed("ui_right"):
			parentOfCells.position = parentOfCells.position + (Vector2.LEFT * speed) * delta
		if Input.is_action_pressed("ui_up"):
			parentOfCells.position = parentOfCells.position + (Vector2.DOWN * speed) * delta
	

func selectInitTile():
	if not isInitTileSelected:
		var pos = inputHandler.getMousePos(get_global_mouse_position(), mapOffset)
		if pos >= Vector2i.ZERO:
			startCell = map.selectCell(pos, settings.colorSettings.startAndFinishColor)
			isInitTileSelected = true

func selectTargetTile():
	if not isTargetTileSelected and isInitTileSelected:
		goalCell = map.selectCell(inputHandler.getMousePos(get_global_mouse_position(), mapOffset), settings.colorSettings.startAndFinishColor)
		isTargetTileSelected = true

func makeMap():
	isInitTileSelected = false
	isTargetTileSelected = false
	startCell = null
	goalCell = null
	walls.clear()

	if parentOfCells:
		parentOfCells.queue_free()
	height = settings.HEIGHT
	width = settings.WIDTH
	map = $"../Map" as Map
	map.init(height, width, cellScene, settings.cellSize)
	map.createMap()
	
	parentOfCells = $"../Map".get_child(0)
	mapOffset = map.mapOffset
	
	inputHandler = InputHandler.new(Vector2(width, height), settings.cellSize, map.mapOffset)

	

func execute():
	if startCell and goalCell:
		algorithm = AStar.new(startCell, goalCell, walls, timer, settings)
		algorithm.execute()
		timer.start(settings.time)

func getInputHandler() -> InputHandler:
	return inputHandler

func getAlgorithm() -> AStar:
	return algorithm
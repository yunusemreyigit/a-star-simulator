extends Node2D

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
var mapOffset

var height
var width
var cellScene = preload("res://scenes/cell.tscn")

var algorithm

func _ready() -> void:
	height = settings.HEIGHT
	width = settings.WIDTH
	map = $"../Map" as Map
	map.init(height, width, cellScene, settings.cellSize)
	map.createMap()
	inputHandler = InputHandler.new(Vector2(width, height), settings.cellSize, map.mapOffset)
	parentOfCells = $"../Map/ParentOfCells"
	mapOffset = map.mapOffset

func _process(delta: float) -> void:
	if parentOfCells:
		mapOffset = parentOfCells.position

	if Input.is_action_just_pressed("click"):
		selectTargetTile()
		selectInitTile()
	
	if startCell and goalCell:
		if Input.is_key_pressed(KEY_SPACE):
			algorithm = AStar.new(startCell, goalCell, walls, timer, settings)
			algorithm.execute()
			timer.start(settings.time)
			
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
		
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
	

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

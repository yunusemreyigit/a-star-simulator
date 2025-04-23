class_name InputHandler

var _mapSize: Vector2
var _cellSize: float
var _mapOffset: Vector2

func _init(mapSize: Vector2, cellSize: float, mapOffset: Vector2) -> void:
	_mapSize = mapSize - Vector2.ONE
	_cellSize = cellSize
	_mapOffset = mapOffset

func getMousePos(mousePos: Vector2, mapOffset: Vector2) -> Vector2i:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		var pos = MyUtils.transformPixelPositionToGridPositionWithOffset(mousePos, mapOffset, _cellSize)
		if pos.x >= 0 and pos.y >= 0 and pos.x <= _mapSize.x and pos.y <= _mapSize.y:
			return pos
		else:
			return Vector2i.MIN
	else:
		return Vector2i.MIN
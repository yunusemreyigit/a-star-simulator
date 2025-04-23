extends Node2D
class_name Cell

var g:float
var h:float
var f:float
var neighbours: Array[Cell]
var previous: Cell

@export var GText: Label
@export var HText: Label
@export var FText: Label
@export var textureRect: TextureRect

func showText():
	GText.get_parent().visible = true

func updateTexts():
	GText.text = str(int(g))
	HText.text = str(int(h))
	FText.text = str(int(f))

func setMaxFandH():
	var max_int = 122337203685477580
	h = max_int
	g = max_int
	
func getTextureSize() -> float:
	return scale.x * 48 
	
func setTextureSize(_size: float):
	scale = Vector2(_size,_size) / 48.0

func setColor(color: Color):
	textureRect.get_material().set_shader_parameter("color", color)

#TODO: This can be false because of mapoffset
func getMapPosition() -> Vector2i:
	return position / getTextureSize()

func setMapPosition(pos: Vector2i):
	position = pos * getTextureSize()
	
func setNeighbours(neighboursArray: Array):
	neighbours = neighboursArray

func getNeighbours() -> Array:
	return neighbours

func getNeighbour(pos: Vector2i):
	for cell:Cell in getNeighbours():
		if cell.getMapPosition() == pos:
			return cell

func extractNeighbour(direction: Vector2i):
	getNeighbours().erase(getNeighbour(getMapPosition() + direction))

func setPreviousCell(prevCell: Cell):
	previous = prevCell

func getPreviousCell() -> Cell:
	return previous

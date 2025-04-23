extends Node

func transformPixelPositionToGridPositionWithOffset(from: Vector2, offset: Vector2,gridCellSize: float) -> Vector2i:
	return ((from - offset) / gridCellSize).floor()

func transformPixelPositionToGridPosition(from: Vector2, gridCellSize: float) -> Vector2i:
	return transformPixelPositionToGridPositionWithOffset(from, Vector2.ZERO, gridCellSize)
extends Resource
class_name SimSettings

@export var colorSettings: ColorSettings
@export_range(10,70) var cellSize: int = 40
@export var isTextVisible: bool = true
@export var HEIGHT: int = 10
@export var WIDTH: int = 10
@export_range(0.05, 300) var time: float

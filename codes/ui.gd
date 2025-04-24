extends Control

var colors: ColorSettings = ColorSettings.new()
var settings: SimSettings = SimSettings.new()
@export var gameManager: GameManager
var activateCounter: int = 0

var setting1: SimSettings = preload("res://resources/SimSettings.tres")
var setting2: SimSettings = preload("res://resources/SmallCell.tres")

@export var excuteButton: Button
@export var applyButton: Button
@export var resetButton: Button

var cellSize: int = 48
var textVisibility: bool = false
var row: int = 10
var column: int = 10
var time: float = 0.05

func _process(delta):
	if gameManager.getAlgorithm():
		if gameManager.getAlgorithm().getIsExecutionCompleted() == false:
			excuteButton.disabled = true
			applyButton.disabled = true
			resetButton.disabled = true
		else:
			excuteButton.disabled = false
			applyButton.disabled = false
			resetButton.disabled = false
	

func _on_startend_color_changed(color:Color) -> void:
	colors.startAndFinishColor = color

func _on_neighbour_color_changed(color:Color) -> void:
	colors.neighbourColor = color

func _on_wall_color_changed(color:Color) -> void:
	colors.wallColor = color

func _on_path_color_changed(color:Color) -> void:
	colors.pathColor = color

func _on_visited_color_changed(color:Color) -> void:
	colors.visitedColor = color

func _on_line_edit_text_changed(new_text:String) -> void:
	cellSize = int(new_text)

func _on_row_line_edit_text_changed(new_text:String) -> void:
	row = int(new_text)

func _on_column_line_edit_text_changed(new_text:String) -> void:
	column = int(new_text)

func _on_check_box_pressed() -> void:
	textVisibility = true if textVisibility == false else false

func _on_time_slider_value_changed(value:float) -> void:
	time = value

func _on_apply_button_pressed() -> void:
	settings.cellSize = cellSize
	settings.HEIGHT = row
	settings.WIDTH = column
	settings.isTextVisible = textVisibility
	settings.time = time

	settings.colorSettings = colors
	gameManager.settings = settings
	gameManager.makeMap()

func _on_execute_pressed() -> void:
	gameManager.execute()

func _on_button_pressed() -> void:
	gameManager.makeMap()

func _on_bg_panel_mouse_entered() -> void:
	activateCounter += 1
	activateInput()

func _on_bg_panel_mouse_exited() -> void:
	activateCounter -= 1
	activateInput()

func activateInput():
	if (activateCounter > 0):
		gameManager.getInputHandler().deactivated()
	else:
		gameManager.getInputHandler().activated()


func _on_hard_reset_pressed() -> void:
	get_tree().reload_current_scene()

func _on_preset_item_selected(index:int) -> void:
	if index == 0:
		settings = setting1
	elif index == 1:
		settings = setting2
	print(index)
	gameManager.settings = settings
	gameManager.makeMap()

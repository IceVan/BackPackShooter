extends Node
class_name VectorUtilsGlobal 

static func getGlobalVectorToMouse(canvas : CanvasItem, node : Node = canvas) -> Vector2:
	return canvas.get_global_mouse_position() - node.global_position

static func getGlobalDirectionToMouse(canvas : CanvasItem, node : Node = canvas) -> Vector2:
	return getGlobalVectorToMouse(canvas, node).normalized()

static func getRandomInsideCircle(size : float = 1.0) -> Vector2:
	var theta : float = randf() * 2 * PI
	return Vector2(cos(theta), sin(theta)) * sqrt(randf()) * size

static func getRandomPointInsideControl(control : Control, offsetSizeX = 0, offsetSizeY = 0) -> Vector2:
	#TODO fix getting size since it returns wrong data
	#print_debug("X: ", control.size.x, " Y: ", control.size.y, " R: ", control.get_transform())
	if(offsetSizeX > control.size.x || offsetSizeY > control.size.y):
		return Vector2.ZERO
	return Vector2(randf_range(0, control.size.x - offsetSizeX), randf_range(0, control.size.y - offsetSizeY))

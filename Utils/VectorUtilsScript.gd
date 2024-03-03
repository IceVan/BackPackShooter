class_name VectorUtilsGlobal 

static func getGlobalVectorToMouse(canvas : CanvasItem, node : Node = canvas) -> Vector2:
	return canvas.get_global_mouse_position() - node.global_position

static func getGlobalDirectionToMouse(canvas : CanvasItem, node : Node = canvas) -> Vector2:
	return getGlobalVectorToMouse(canvas, node).normalized()

extends TextureRect
class_name InventoryCell

@export var itemRef : InventoryItem

@onready var filter = $StatusFilter

var cellID
var isHovering : bool = false
var state = States.DEFAULT
enum States {DEFAULT, INACTIVE, TAKEN, FREE}

signal cellEntered(cell)
signal cellExited(cell)

func setColor(aState = States.DEFAULT) -> void:
	match aState:
		States.DEFAULT:
			filter.color = Color(Color.WHITE, 0.0)
		States.TAKEN:
			filter.color = Color(Color.RED, 0.2)
		States.FREE:
			filter.color = Color(Color.GREEN, 0.2)

func _process(delta):
	if get_global_rect().has_point(get_global_mouse_position()):
		if not isHovering:
			isHovering = true
			emit_signal("cellEntered", self)
	else:
		if isHovering:
			isHovering = false
			emit_signal("cellExited",self)

extends CanvasLayer

@onready var smap := $SystemMap
@onready var mmap := $MainMap

var current_map := 0:
	set(value):
		current_map = clamp(value, 0, 1)
		match current_map:
			0:	# main map
				smap.hide()
				mmap.show()
			1:	# system map
				smap.show()
				mmap.hide()
			_:
				print_debug("PlayerMap set map value to something not expected")
	get:
		return current_map

func draw_system(system:GeneratedSystem):
	smap.draw_system(system)

func _ready():
	current_map = 0

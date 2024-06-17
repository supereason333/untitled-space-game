extends CanvasLayer

@onready var smap := $SystemMap
@onready var mmap := $MainMap

var current_map := 1:
	set(value):
		current_map = clamp(current_map, 0, 1)
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

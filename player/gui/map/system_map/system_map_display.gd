extends Control

@onready var system_draw := $SubViewportContainer/SubViewport/SystemDraw

func update_size():
	$SubViewportContainer/SubViewport.size = $SubViewportContainer.size

func draw_system(system:GeneratedSystem):
	system_draw.draw_system(system, 0)


func _on_spin_box_value_changed(value):
	system_draw.zoom = value
	system_draw.update_draw()

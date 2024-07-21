extends Control

@onready var system_map := $CenterContainer/HBoxContainer/MapPanel/SystemMap/SystemMapDisplay

func _ready():
	system_map.update_size()

func draw_system(system:GeneratedSystem):
	system_map.draw_system(system)

func _on_map_panel_tab_clicked(tab):
	system_map.update_size()

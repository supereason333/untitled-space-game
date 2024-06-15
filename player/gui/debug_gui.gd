extends CanvasLayer

var info_box = preload("res://player/gui/debug_gui/info_box.tscn")

@onready var sysinfbox := $SystemInfoContainer

func _ready():
	self.visible = false

func _process(delta):
	if Input.is_action_just_pressed("debug_menu_toggle"):
		self.visible = !self.visible
		if self.visible:
			update_display()

func update_display():
	for child in sysinfbox.get_children():
		child.queue_free()
	var data = []
	get_tree().call_group("game", "get_info", data)
	for info in data:
		var box = info_box.instantiate()
		box.data_name = info[0]
		box.data_value = info[1]
		sysinfbox.add_child(box)

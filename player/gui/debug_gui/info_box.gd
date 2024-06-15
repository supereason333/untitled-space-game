extends HBoxContainer

var data_name := "Data Name":
	set(value):
		data_name = value
		$Name.text = str(value)
	get:
		return data_name

var data_value = "data":
	set(value):
		data_value = value
		$Data.text = str(value)
	get:
		return data_value

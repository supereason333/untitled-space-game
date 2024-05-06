extends Node

const GRAV_CONST := 0.0000000000667408

var rnd = RandomNumberGenerator.new()

func rnd_from_chance(input: float):			# chooses true/false from a chance. Input = 0.3 -> 30% to return true
	if input < rnd.randf(): return false
	else: return true


func exp_rndi_range(min: int, max: int):
	max += 1
	return int(rnd.randf_range(0, max) * rnd.randf_range(0, max) / max) + min

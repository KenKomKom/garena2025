extends Area2D

func _on_area_entered(area):
	if area.name == "TheDeathArea":
		$"../..".is_aggresive_fish_in_death_area = true
		


func _on_area_exited(area):
	if area.name == "TheDeathArea":
		$"../..".is_aggresive_fish_in_death_area = false

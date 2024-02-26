extends StaticBody2D

func _on_collision_area_area_entered(area):
	print(area.get_parent())
	if area.get_parent().is_big:
		queue_free()
		

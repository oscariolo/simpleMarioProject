extends StaticBody2D
@onready var animated_sprite = $AnimatedSprite2D
@export var prize: PackedScene #crea un paquete para ese objeto

func _on_hit_box_area_entered(area):
	if animated_sprite.animation != "empty":
		animated_sprite.play("empty")
		_throw_object()

func _throw_object():
	var prize_inst = prize.instantiate()
	get_tree().root.call_deferred("add_child",prize_inst)
	prize_inst.global_position = global_position + Vector2(0,-15)

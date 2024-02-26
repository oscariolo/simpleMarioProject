extends CharacterBody2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const SPEED = 80
var dir = 1

func _physics_process(delta):
	_movement_process(delta)
	move_and_slide()

	
func _movement_process(delta):
	velocity.y += gravity * delta
	##por defualt se movera para la derecha hasta que choque contra un muro
	velocity.x = SPEED * dir
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("walls"):
		dir *= -1
		



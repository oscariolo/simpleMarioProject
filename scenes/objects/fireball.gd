extends CharacterBody2D

const GRAVITY =  1
const JUMP_FORCE = 8
var dir
var SPEED = 7

func _physics_process(delta):
	_apply_gravity()
	velocity.x = SPEED * dir
	if move_and_collide(velocity):
		_jump()


func set_dir(dir):
	if dir:
		self.dir = 1
	else:
		self.dir = -1

func _apply_gravity():
	velocity.y += GRAVITY

func _jump():
	velocity.y = -JUMP_FORCE

func _on_timer_timeout():
	queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("walls"):
		queue_free()
	if body.is_in_group("enemy"):
		queue_free()
func _on_area_2d_area_entered(area):
	queue_free()

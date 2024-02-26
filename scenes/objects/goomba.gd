extends CharacterBody2D
const GRAVITY = 1
const SPEED = 40
var dir = 1
@onready var animations = $Animations
signal hurt_player

func _physics_process(delta):
	_apply_gravity()
	velocity.x = SPEED * dir
	move_and_slide()

func _apply_gravity():
	velocity.y += GRAVITY

func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		animations.play("death")
		$HurtBox.get_child(0).call_deferred("set_disabled",true)
		$CollisionShape2D.call_deferred("set_disabled",true)
		await get_tree().create_timer(1).timeout
		queue_free()

func _on_hurt_box_area_entered(area):
	if area.get_parent().is_in_group("walls"):
		dir *= -1
	if area.get_parent().is_in_group("player"):
		emit_signal("hurt_player")
	if area.get_parent().is_in_group("throwable"):
		$HurtBox.get_child(0).call_deferred("set_disabled",true)
		$CollisionShape2D.call_deferred("set_disabled",true)
		await get_tree().create_timer(1).timeout
		queue_free()
	
		


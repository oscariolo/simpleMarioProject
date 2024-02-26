extends CharacterBody2D

const SPEED = 200
const JUMP_SPEED = -350
var score = 0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_big = false
var is_fire = false
const jumpMultiplier = 100
const fallMultiplier = 20
const SPRINT_MULTIPLIER = 2
@onready var animations = $Animations
@export var fire_ball: PackedScene

func _ready():
	#is_fire = true
	#_swap_collition_shape()
	pass

func _physics_process(delta):
	var direction = Input.get_axis("move_left","move_right")
	_manage_movement(direction,delta)
	_manage_animations(direction)
	move_and_slide()

func _shoot():
	var fire_ball_inst = fire_ball.instantiate()
	get_tree().root.call_deferred("add_child",fire_ball_inst)
	fire_ball_inst.global_position = global_position
	fire_ball_inst.set_dir(not animations.flip_h)

func _manage_movement(direction,delta):
	velocity.y += gravity * delta #aplicar constante gravedad al personaje
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_SPEED 
	
	if Input.is_action_just_pressed("shoot") and is_fire:
		_shoot()
	
	if Input.is_action_pressed("sprint") and is_on_floor(): #si corre aumenta x
		velocity.x = direction * SPEED * SPRINT_MULTIPLIER
	else:
		velocity.x = direction * SPEED
	#manejo de fallouts de salto,asi como mario
	#si mantiene aplastado el de saltar salta mas alto
	if velocity.y > 0: #Jugador esta cayendo (cuando cae y es positivo)
		#como en mario la caida es mas rapida que el salto como tal
		#se agrega un peso mas a la caida
		velocity.y += gravity * delta 
	elif velocity.y < 0 and Input.is_action_just_released("jump"): #Player is jumping and released	
		#al saltar y soltar el boton de salto debe comenzar a caer 
		#el peso que se le da para la caida debe contrarrestar aun mas
		#el del salto para que caiga rapido
		#si sigue saltando el salto aumenta hasta el punto que contrarresta la gravedad
		#si suelta se contrarresta con un peso mayor para que caiga
		velocity.y += gravity * delta * 10
func _manage_animations(direction):
	if direction < 0:
		animations.flip_h = true
	elif direction > 0:
		animations.flip_h = false
	if is_fire:
		if not is_on_floor():
			animations.play("jumping_fire")
		elif direction == 0:
			animations.play("idle_fire")
		else:
			animations.play("walking_fire")
	elif is_big:
		if not is_on_floor():
			animations.play("jumping_big")
		elif direction == 0:
			animations.play("idle_big")
		else:
			animations.play("walking_big")
	else:
		if not is_on_floor():
			animations.play("jumping_small")
		elif direction == 0:
			animations.play("idle_small")
		else:
			animations.play("walking_small")

func _on_hit_box_area_entered(area):
	print(area.get_parent())
	if area.get_parent().is_in_group("mushrooms"):
		is_big = true
		area.get_parent().call_deferred("queue_free")
		_swap_collition_shape()
	elif area.is_in_group("flowers"):
		is_fire = true
		is_big = true
		area.call_deferred("queue_free")
		_swap_collition_shape()
func _swap_collition_shape(set_small=false):
	$CollisionShape_small.call_deferred("set_disabled",not set_small)
	$CollisionShape_big.call_deferred("set_disabled",set_small)	
		
func _on_goomba_hurt_player():
	if not is_big:
		queue_free()
	elif is_fire:
		is_fire = false
		$HitBox.get_child(0).call_deferred("set_disabled",true)
		$Invulnerable.start()
	elif is_big:
		is_big = false
		$HitBox.get_child(0).call_deferred("set_disabled",true)
		$Invulnerable.start()
		_swap_collition_shape(true)

func _on_invulnerable_timeout():
	$HitBox.get_child(0).call_deferred("set_disabled",false)

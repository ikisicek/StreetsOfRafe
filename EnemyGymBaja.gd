extends KinematicBody2D

export(int) var lives = 2
export(int) var SPEED = 100
export(int) var ATTACKSPEED = 200
export(int) var hp = 1
export(Vector2) var size = Vector2(1,1)
const FLOOR = Vector2(0,0)
const FIREBALL = preload ("res://assets/knock_fireball/EnemyBullet.tscn")

var direction = 1
var velocity = Vector2()
var is_dead = false
var is_attacking = false
var attacktime = 0
onready var liverlabel = get_node("EnemyLives")
var stop = false
var EnemyPositionY = 0
var EnemyPositionX = 0
var gleda_u_playera = false
var udaren_je = false

func _ready():
	is_dead = false
	#scale = size
	var enemy_lives_text = String(lives)
	liverlabel.clear()
	liverlabel.add_text(enemy_lives_text)

func _physics_process(delta):
	EnemyPositionX = position.x
	EnemyPositionY = position.y
	z_index = EnemyPositionY
	#if is_dead == false and is_attacking == false and stop == false:
	if is_dead == false and stop == false:
		velocity.x = SPEED * direction
		if direction == 1:
			$AnimatedSprite.flip_h = false
			$RayCast2D.rotation_degrees=270
			$RayCast2D.position.x = 10
		else:
			$AnimatedSprite.flip_h = true
			$RayCast2D.position.x = -10
			$RayCast2D.rotation_degrees=90
			#$Position2D.position.x *= -1
			#$AttackPlayerArea/CollisionShape2D.position.x *= -1
		if is_attacking==false:	
			$AnimatedSprite.play("walk")
		if is_attacking==true and global.enemy_metak == false:
			$AnimatedSprite.play("attack")
		velocity.y = 0
		velocity = move_and_slide(velocity, FLOOR)
	if stop == true:
		velocity.x = 0
	else:
		velocity.x = SPEED * direction
		
	if udaren_je == true:
		if is_dead == false:
			$AnimationPlayer.play("anim_hurt")
			$AnimatedSprite.play("hurt")
	
	if is_dead == true:
		$AnimatedSprite.play("dead")
		#$AnimationPlayer.stop()
		$CollisionShape2D.disabled = true
		$EnemyArea/CollisionShape2D.disabled = true
		$AttackPlayerArea/CollisionShape2D.disabled = true
		$HurtArea/CollisionShape2D.disabled = true
	
	if global.enemy_metak == true and is_attacking == true:
		$AnimatedSprite.play("pucaj")
		#$PunchAudio.play()
		
func _on_EnemyArea_body_entered(body):
	if "Player" in body.name:
		is_attacking = true
		$AnimatedSprite.play("attack")
	#if is_attacking == false:
	if gleda_u_playera == false:
		direction = direction * -1
		$Position2D.position.x *= -1
		$AttackPlayerArea/CollisionShape2D.position.x *= -1

func attack():
	if udaren_je == false and is_dead == false and is_attacking == true:
		var fireball = FIREBALL.instance()
		if sign($Position2D.position.x) == 1:
			fireball.set_fireball_direction(1)
			$AnimatedSprite.play("pucaj")
		if sign($Position2D.position.x) == -1:
			fireball.set_fireball_direction(-1)
			$AnimatedSprite.play("pucaj")
		get_parent().add_child(fireball)
		fireball.position = $Position2D.global_position

func _on_AttackPlayerArea_body_entered(body):
	if "Player" in body.name:
		SPEED = ATTACKSPEED
		gleda_u_playera = true
#		if $RayCast2D.is_colliding() == true:
#			$AttackTImer.start()
#		elif $RayCast2DLeft.is_colliding() == true:
#			$AttackTImer.start()
			
func _on_AttackTImer_timeout():
	attacktime = attacktime + 1
	if attacktime%2 == 0:
		attack()
		
func _on_AttackPlayerArea_body_exited(body):
	if "Player" in body.name:
		SPEED = 100
		gleda_u_playera = false
		stop = false
		is_attacking = false
		#$AttackTImer.stop()
	
func _on_EnemyArea_body_exited(body):
	if "Player" in body.name:
		is_attacking = false
		stop = false
		
func hurt():
	#$AnimatedSprite.play("hurt")
	var enemy_lives_text = String(lives)
	liverlabel.clear()
	liverlabel.add_text(enemy_lives_text)
	if lives > 0:
		lives = lives - 1
	else:
		#dead()
		lives = 0
	
	if lives == 0:
		global.enemy_killed += 1
		dead()
		
func dead():
	if direction == 1:
		position.x = position.x - 100
	if direction == -1:
		position.x = position.x + 100
	$DeadTimer.start()
	$AnimatedSprite.play("dead")
	$DeadAudio.play()
#	$CollisionShape2D.disabled = true
	is_dead = true

func _on_HurtArea_area_entered(area):
	if area.is_in_group("playerbullet"):
		print(lives)
		udaren_je = true
		$HurtStopTimer.start()
		hurt()
		
#Stani - kreni:

func _on_EnemyArea_area_entered(area):
	if area.is_in_group("enemy_stop"):
		stop = true
		$AttackTImer.start()
		if gleda_u_playera == false:
			stop = false
			direction *= -1
			$AttackPlayerArea/CollisionShape2D.position.x *= -1
			$Position2D.position.x *= -1
	if area.is_in_group("leveltimer"):
		direction = direction * -1
#	if area.is_in_group("enemy_stop"):
#		$AttackTImer.start()

func _on_EnemyArea_area_exited(area):
	if area.is_in_group("player_hurt_area"):
		stop = false
#		is_attacking = false
	if area.is_in_group("enemy_stop"):
		$AttackTImer.stop()
		
func _on_AnimatedSprite_animation_finished():
	if is_dead == false and is_attacking == false:
		$AnimatedSprite.play("walk")
		
func _on_HurtStopTimer_timeout():
	if is_dead == false:
		udaren_je = false
		$AnimatedSprite.play("attack")
	
func _on_DeadTimer_timeout():
	queue_free()

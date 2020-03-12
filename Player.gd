extends KinematicBody2D

#export(int) var LIVES = 10
var direction = Vector2()
var velocity
var player_stop = false

const TOP = Vector2(0,-1)
const RIGHT = Vector2(1,0)
const DOWN = Vector2(0,1)
const LEFT = Vector2(-1,0)

export var speed = 1000
const max_speed = 8000

const FIREBALLKNOCK = preload("res://assets/knock_fireball/FireballKnock.tscn")
const FIREBALLPUNCH = preload("res://assets/knock_fireball/FireballPunch.tscn")
#const ENEMY_NEPRATI = preload("res://Enemy/Enemy.tscn")
#const ENEMY_PRATI = preload("res://Enemy/EnemyFollow.tscn")

var AttackPosition = 7
var PlayerPositionX = 0
var PlayerPositionY = 0
var is_dead = false
var is_jump = false
var jumptime = 0
var is_attacking = false
var udaren_je = false
var punch_attack_time = 0
var ne_moze_skocit = false
var moze_kick_jump = true

#Kontrole:
var left_touch = false
var right_touch = false
var up_touch = false
var down_touch = false
var jump_touch = false
var punch_touch = false

func _ready():
	is_dead = false
	$AnimatedSprite.play("idle")
	set_process(true)
	
func _physics_process(delta):
	if punch_touch == false:
		get_parent().get_node("Controls/Punch").set_block_signals(true)
	PlayerPositionY = position.y
	z_index = PlayerPositionY
	PlayerPositionX = position.x
	if is_dead == false:
		if is_jump == false and punch_touch== false:
			if udaren_je == false:
				if (Input.is_action_pressed("ui_up") or up_touch == true) and is_attacking == false and is_jump == false:
					direction = TOP
					speed = max_speed
					$AnimatedSprite.play("run_up")
					get_parent().get_node("Controls/Joystick").play("up")
				elif (Input.is_action_pressed("ui_down") or down_touch == true) and is_attacking == false and is_jump == false:
					direction = DOWN
					speed = max_speed
					$AnimatedSprite.play("run_down")
					get_parent().get_node("Controls/Joystick").play("down")
				elif (Input.is_action_pressed("ui_right") or right_touch == true) and is_attacking == false and is_jump == false:
					$AnimatedSprite.flip_h = false
					$Position2DPunch.position.x = AttackPosition
					$Position2DKnock.position.x = AttackPosition
					direction = RIGHT 
					speed = max_speed
					$AnimatedSprite.play("run_right")
					get_parent().get_node("Controls/Joystick").play("right")
			
				elif (Input.is_action_pressed("ui_left") or left_touch == true) and is_attacking == false and is_jump == false:
					$AnimatedSprite.flip_h = true
					$Position2DPunch.position.x = -AttackPosition
					$Position2DKnock.position.x = -AttackPosition
					direction = LEFT
					speed = max_speed
					$AnimatedSprite.play("run_left")
					get_parent().get_node("Controls/Joystick").play("left")
				else:
						#$AnimatedSprite.play("idle")
					speed = 0
					if Input.is_action_just_released("ui_up"):
						$AnimatedSprite.play("idle_up")
					if Input.is_action_just_released("ui_down"):
						$AnimatedSprite.play("idle")
					if Input.is_action_just_released("ui_left"):
						$AnimatedSprite.play("idle_left")
					if Input.is_action_just_released("ui_right"):
						$AnimatedSprite.play("idle_right")
					get_parent().get_node("Controls/Joystick").play("idle")
		else:
			if is_jump == false:
				speed = 0
		if is_jump == true:
			if direction == RIGHT:
				position.x = position.x + 1
			if direction == LEFT:
				position.x = position.x - 1

		if player_stop == true:
			speed = 100
						
		if Input.is_action_just_pressed("ui_select") or jump_touch == true and ne_moze_skocit == false:
			is_jump = true
			$JumpTimer.start()
			if is_jump == true and is_attacking == false:
				$AnimatedSprite.play("jump")
#				$CollisionShape2D.disabled = true
#		if is_jump == false:
#			$CollisionShape2D.disabled = false

		#prvi nacin kick:	
		if Input.is_action_just_pressed("ui_knock"):
			$AnimatedSprite.play("kick")
			var fireballknock = FIREBALLKNOCK.instance()
			if sign($Position2DKnock.position.x) == 1:
				fireballknock.set_fireball_direction(1)
			if sign($Position2DKnock.position.x) == -1:
				fireballknock.set_fireball_direction(-1)
			get_parent().add_child(fireballknock)
			fireballknock.position = $Position2DKnock.global_position
		#drugi nacin kick:

		if Input.is_action_just_pressed("ui_punch") or punch_touch == true and is_jump == true and moze_kick_jump == true:
			$AnimatedSprite.play("kick")
			$KickAudio.play()
			is_attacking = true
			var fireballknock = FIREBALLKNOCK.instance()
			if sign($Position2DKnock.position.x) == 1:
				fireballknock.set_fireball_direction(1)
			if sign($Position2DKnock.position.x) == -1:
				fireballknock.set_fireball_direction(-1)
			get_parent().add_child(fireballknock)
			fireballknock.position = $Position2DKnock.global_position
			
			#punch
		if Input.is_action_just_pressed("ui_punch") or punch_touch==true and is_jump == false and is_attacking==false:
			is_attacking = true
			$AnimatedSprite.play("punch")
			$PunchAudio.play()
			var fireballpunch = FIREBALLPUNCH.instance()
			if sign($Position2DPunch.position.x) == 1:
				fireballpunch.set_fireball_direction(1)
			if sign($Position2DPunch.position.x) == -1:
				fireballpunch.set_fireball_direction(-1)
			get_parent().add_child(fireballpunch)
			fireballpunch.position = $Position2DPunch.global_position
		
		if Input.is_action_just_released("ui_punch") or punch_touch==false:
			is_attacking = false
			
		velocity = speed * direction * delta
		move_and_slide(velocity)
	
	else:
		$DeadTimer.start()
func hurt():
	$AnimatedSprite.play("hurt")
	$AnimationPlayerHurt.play("hurt")
	$HurtAudio.play()
	print("lives:")
	print(global.player_lives)
	if global.player_lives > 0:
		global.player_lives = global.player_lives - 1
	else:
		global.player_lives == 0
		player_dead()

func player_dead():
	$DeadAudio.play()
	get_parent().get_node("GameOverMenu/RESTART").visible = true
	get_parent().get_node("GameOverMenu/QUIT").visible = true
	$AnimatedSprite.play("dead")
	#$AnimationPlayer.play("dead")
	#$HurtArea/CollisionShape2D.disabled = true
#	$CollisionShape2D.disabled = true
	is_dead = true
	#visible = false
	get_parent().get_node("LevelTimer").stop()
	
	
func _on_HurtArea_area_entered(area):
	if is_dead == false:
		if area.is_in_group("enemybullet"):
			udaren_je = true
			print(global.player_lives)
			hurt()

func _on_EnemyStopArea_area_entered(area):
	if area.is_in_group("enemy_area"):
		#player_stop = true
		pass
	if area.is_in_group("enemy_stop"):
		#player_stop = true
		pass
	if area.is_in_group("leveltimer"):
		ne_moze_skocit = true
		if is_jump == true:
			is_jump = false
	if area.is_in_group("bosshurt"):
		moze_kick_jump = false
		print("NEMA KICK")


func _on_EnemyStopArea_area_exited(area):
	if area.is_in_group("enemy_area"):
		player_stop = false
	if area.is_in_group("enemy_stop"):
		player_stop = false
	if area.is_in_group("leveltimer"):
		ne_moze_skocit = false
	if area.is_in_group("bosshurt"):
		moze_kick_jump = true
		print ("MOZES KICKAT")
		
func _on_JumpTimer_timeout():
	is_jump = false

func _on_AnimatedSprite_animation_finished():
	if speed == 0 and is_dead == false:
		$AnimatedSprite.play("idle")

func _on_DeadTimer_timeout():
	visible = false

func _on_HurtArea_area_exited(area):
	if area.is_in_group("enemybullet"):
		udaren_je = false
	
		
#KONTROLE
func _on_Left_pressed():
	left_touch = true

func _on_Right_pressed():
	right_touch = true

func _on_Up_pressed():
	up_touch = true

func _on_Down_pressed():
	down_touch = true


func _on_Left_released():
	left_touch = false

func _on_Right_released():
	right_touch = false

func _on_Up_released():
	up_touch = false

func _on_Down_released():
	down_touch = false


func _on_Jump_pressed():
	jump_touch = true
	get_parent().get_node("Controls/JumpTouchTimer").start()
	get_parent().get_node("Controls/AttackTimer").start()

func _on_Punch_pressed():
	punch_touch = true
	#get_parent().get_node("Controls/PunchTouchTimer").start()
	#get_parent().get_node("Controls/AttackTimer").start()

func _on_Jump_released():
	jump_touch = false

func _on_Punch_released():
	punch_touch = false
	
func _on_JumpTouchTimer_timeout():
	jump_touch = false

func _on_PunchTouchTimer_timeout():
	punch_touch = false

func _on_AttackTimer_timeout():
	punch_attack_time += 1
	if punch_attack_time < 2:
		is_attacking = true
	else:
		is_attacking = false


func _on_Right3_pressed():
	pass # Replace with function body.


func _on_Right3_released():
	pass # Replace with function body.


func _on_Up3_pressed():
	pass # Replace with function body.


func _on_Up3_released():
	pass # Replace with function body.


func _on_Down2_pressed():
	pass # Replace with function body.


func _on_Down2_released():
	pass # Replace with function body.

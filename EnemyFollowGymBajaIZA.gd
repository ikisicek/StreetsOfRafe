extends KinematicBody2D

export(int) var LIVES = 2
#export(int) var SPEED = 100
#export(int) var ATTACKSPEED = 200
export(int) var HP = 1
export(Vector2) var size = Vector2(1,1)

const FIREBALL = preload("res://assets/knock_fireball/EnemyBullet.tscn")
var is_attacking = false

onready var target = get_parent().get_parent().get_node("Player")
onready var targetRED = get_parent().get_parent().get_node("Player2")
onready var targetUSA = get_parent().get_parent().get_node("Player3")
export var BRZINA = 50
var speed = 50
var zom = self
var velocity = Vector2()
var attacktime = 0
var prati_igraca = false
var EnemyPositionY = 0
var EnemyPositionX = 0
var pucaj_na_igraca = false
var zakljucan = false
var udaren_je = false
var napao_je = false
var kreni = false
var is_dead = false
onready var liverlabel = get_node("EnemyLives")

func _ready():
	is_dead = false
	$AnimatedSprite.play("idle")
	if global.player == true:
		target = target 
	elif global.playerRED == true:
		target = targetRED
	else:
		target = targetUSA
	
	#scale = size
	var enemy_lives_text = String(LIVES)
	liverlabel.clear()
	liverlabel.add_text(enemy_lives_text)

func _physics_process(delta):
	speed = BRZINA
	if udaren_je == true:
		$AnimationPlayer.play("hurt_anim")
	EnemyPositionY = position.y
	EnemyPositionX = position.x
	z_index = EnemyPositionY
	if is_dead == false:
		if kreni == true:
			visible = true
			if prati_igraca == true and zakljucan == false:
				#$AnimatedSprite.play("walk")
				var direction = (target.global_position - global_position).normalized()
				move_and_slide(direction * speed)	
				if pucaj_na_igraca == false:
					$Position2D.position.x *= -1
					$ShootPlayerArea/CollisionShape2D.position.x = $ShootPlayerArea/CollisionShape2D.position.x *-1
				else:
				#	$AnimatedSprite.flip_h = false
					#$Position2D.position.x = 10
					$ShootPlayerArea/CollisionShape2D.position.x = $ShootPlayerArea/CollisionShape2D.position.x * 1
				
				if $Position2D.position.x > 0:
					$AnimatedSprite.flip_h = false
				if $Position2D.position.x < 0:
					$AnimatedSprite.flip_h = true
					
				if prati_igraca == true and zakljucan == false and udaren_je == false and napao_je == false and global.enemy_metak == false:
					$AnimatedSprite.play("walk")
				if prati_igraca == false and global.enemy_metak == false:
					$AnimatedSprite.play("idle")
				if prati_igraca == true and zakljucan == false and udaren_je == false and napao_je == true and global.enemy_metak == false:
					$AnimatedSprite.play("attack")
				if prati_igraca == true and zakljucan == false and udaren_je == true and global.enemy_metak == false:
					$AnimatedSprite.play("hurt")
				if global.enemy_metak == true:
					$AnimatedSprite.play("pucaj")
					#$PunchAudio.play()
		else:
			visible = false
	if is_dead == true:
		$AttackPlayerArea/CollisionShape2D.disabled = true
		$HurtArea/CollisionShape2D.disabled = true
		$FollowPlayerArea/CollisionShape2D.disabled = true
		$FollowPlayerArea/CollisionShape2D.disabled = true
		$ShootPlayerArea/CollisionShape2D.disabled = true
		$CollisionShape2D.disabled = true
		$AnimatedSprite.play("dead")
		$Shadow.visible = false
		if target.position.x < position.x:
			position.x = position.x + 0.15
		if target.position.x > position.x:
			position.x = position.x - 0.15
				
		
func attack():
	if is_dead == false:
		if kreni == true:
			if prati_igraca == true:
				if udaren_je == false:
					var fireball = FIREBALL.instance()
					if $Position2D.position.x > 0:
						#$AnimatedSprite.flip_h = false
						fireball.set_fireball_direction(1)
					if $Position2D.position.x < 0:
						#$AnimatedSprite.flip_h = true
						fireball.set_fireball_direction(-1)
					get_parent().add_child(fireball)
					fireball.position = $Position2D.global_position
				
		
func _on_AttackTImer_timeout():
	attacktime = attacktime + 1
	if attacktime%1 == 0:
		#$AnimatedSprite.play("pucaj")
		attack()
		napao_je = true
	else:
		napao_je = false
			
func _on_AttackPlayerArea_area_entered(area):
	if is_dead == false:
		if area.is_in_group("player_hurt_area"):
			$AttackTImer.start()
		if area.is_in_group("door"):
			zakljucan = true
	
func hurt():
	#$AnimationPlayer.play("hurt_anim")
	var enemy_lives_text = String(LIVES)
	liverlabel.clear()
	liverlabel.add_text(enemy_lives_text)
	if LIVES > 0:
		LIVES = LIVES - 1
	else:
		#is_dead = true
		LIVES = 0
	
	if LIVES == 0:
		$DeadAudio.play()
		global.enemy_killed += 1
		is_dead = true
		

func _on_HurtArea_area_entered(area):
	if is_dead == false:
		if area.is_in_group("playerbullet"):
			hurt()
			udaren_je = true
			$HurtStopTImer.start()
			#$HurtArea/CollisionShape2D.disabled = true
		else:
			udaren_je = false
			#$HurtArea/CollisionShape2D.disabled = false
		if area.is_in_group("enemy_stop"):
			speed = 0

func _on_HurtArea_area_exited(area):
	if area.is_in_group("enemy_stop"):
		speed = BRZINA
		
func _on_FollowPlayerArea_area_entered(area):
	if area.is_in_group("player_hurt_area"):
		prati_igraca = true
#		if speed > 0:
#			if target.PlayerPositionX < EnemyPositionX:
#				$AnimatedSprite.flip_h = true
#			else:
#				$AnimatedSprite.flip_h = false
		
func _on_FollowPlayerArea_area_exited(area):
	if area.is_in_group("player_hurt_area"):
		prati_igraca = false



func _on_ShootPlayerArea_area_entered(area):
	if area.is_in_group("player_hurt_area"):
		pucaj_na_igraca = true
		print (pucaj_na_igraca)


func _on_ShootPlayerArea_area_exited(area):
	if area.is_in_group("player_hurt_area"):
		pucaj_na_igraca = false
		print (pucaj_na_igraca)


func _on_AttackPlayerArea_area_exited(area):
	if area.is_in_group("door"):
		zakljucan = false
	if area.is_in_group("player_hurt_area"):
		$AttackTImer.stop()
		napao_je = false


func _on_AnimatedSprite_animation_finished():
	if is_dead == false:
		$AnimatedSprite.play("walk")


func _on_HurtStopTImer_timeout():
	udaren_je = false


func _on_KRENI_area_entered(area):
	if area.is_in_group("player_hurt_area"):
		kreni = true


func _on_KRENI_area_exited(area):
	if area.is_in_group("player_hurt_area"):
		kreni = true

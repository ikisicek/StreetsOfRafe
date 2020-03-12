extends KinematicBody2D

const FIREBALL = preload ("res://assets/knock_fireball/EnemyBullet.tscn")
onready var parent = get_parent()
onready var liveslabel = get_node("LivesLabel")

export(int) var lives = 2
export(int) var SPEED = 100
export(int) var ATTACKSPEED = 200
export(int) var hp = 1
export(int) var NEXT_LEVEL = 0

var tempPos
var is_dead = false
var attacktime = 0
var boss_napada = false
var lijevo = false
var mozes_ga_udariti = false
var BossPositionY = 0
var deadtime = 0
var udaren_je = false


func _ready():
	$AnimatedSprite.play("idle")
	$AttackTimer.start()
	tempPos = $AnimatedSprite.position.x
	boss_napada = false

func _process(delta):
	z_index = 1000
	#print (z_index)
	var livestext = String(lives)
	liveslabel.clear()
	liveslabel.add_text(livestext)

func _physics_process(delta):
	if is_dead == false:
		if parent is PathFollow2D:
			parent.set_offset(parent.get_offset() + SPEED*delta)
			position = Vector2()
		else:
			pass
	if boss_napada == true:
		$AnimatedSprite.play("attack")
		$ShootArea/CollisionShape2D.disabled = false
	else:
		$AnimatedSprite.play("walk")
		$ShootArea/CollisionShape2D.disabled = true
		
	if lijevo == true:
		$AnimatedSprite.flip_h = false
		#$AttackPlayerArea/CollisionShape2D.position.x = -$AttackPlayerArea.position.x
	if lijevo == false:
		$AnimatedSprite.flip_h = true
		
	if is_dead == true:
		$CollisionShape2D.disabled = true
		print("DEAD TIMER JE POCEO")
		print(deadtime)
		z_index = 0

func _on_RotateArea_area_entered(area):
	if area.is_in_group("bossrotate"):
		#$AnimatedSprite.flip_h = true
		lijevo = true
		$Position2D.position.x = $Position2D.position.x
		$RotateArea.position.x = $RotateArea.position.x * -1
		#$AttackPlayerArea.position.x = $AttackPlayerArea.position.x * -1
		$ShootArea/CollisionShape2D.position.x = $ShootArea/CollisionShape2D.position.x * -1
	if area.is_in_group("bossrotate2"):
		#$AnimatedSprite.flip_h = false
		lijevo = false
		$Position2D.position.x = $Position2D.position.x
		$RotateArea.position.x = $RotateArea.position.x * -1
		#$AttackPlayerArea.position.x = $AttackPlayerArea.position.x * -1
		$ShootArea/CollisionShape2D.position.x = $ShootArea/CollisionShape2D.position.x * -1


func _on_AttackPlayerArea_area_entered(area):
	if is_dead == false:
		if area.is_in_group("player_hurt_area"):
			#$AttackTimer.start()
			boss_napada = true

func attack():
	if is_dead == false:
		var fireball = FIREBALL.instance()
#		if sign($Position2D.position.x) > 0:
		fireball.set_fireball_direction(1)
#		if sign($Position2D.position.x) < -1:
#			fireball.set_fireball_direction(-1)
		get_parent().add_child(fireball)
		fireball.position = $Position2D.global_position


func _on_AttackTimer_timeout():
	#print("napadmooOO")
	attacktime = attacktime + 1
	if attacktime%2 == 0:
		mozes_ga_udariti = true
	else:
		mozes_ga_udariti = false

		
		
func _on_AttackPlayerArea_area_exited(area):
	if area.is_in_group("player_hurt_area"):
		boss_napada = false
		#$AttackTimer.stop()


func _on_ChangeSpeedArea_area_entered(area):
	if area.is_in_group("player_hurt_area"):
		SPEED = 250

func _on_ChangeSpeedArea_area_exited(area):
	if area.is_in_group("player_hurt_area"):
		SPEED = 100
		
func hurt():
	if lives > 0:
		lives = lives - 1
	else:
		lives = 0
		
	if lives == 0:
		$DeadTimer.start()
		global.enemy_killed += 1
		dead()
		
func dead():
#	$DeadTimer.start()
#	$AnimatedSprite.play("dead")
#	$CollisionShape2D.disabled = true
	is_dead = true
	#queue_free()
	#get_tree().change_scene("res://UI/Menu.tscn")
	if NEXT_LEVEL == 2:
		global.stage = 2
		global.save_settings()
	if NEXT_LEVEL == 3:
		global.stage = 3
		global.save_settings()
	if NEXT_LEVEL == 4:
		global.stage = 4
		global.save_settings()
	if NEXT_LEVEL == 5:
		global.stage = 5
		global.save_settings()

func _on_HurtArea_area_entered(area):
	if area.is_in_group("playerbullet"):
#		print(lives)
#		udaren_je = true
#		$HurtStopTimer.start()
		if mozes_ga_udariti == true:
			udaren_je = true
			$HurtTimer.start()
			hurt()


func _on_DeadTimer_timeout():
	deadtime = deadtime + 1
	if deadtime > 2:
		get_tree().change_scene("res://UI/Menu.tscn")


func _on_HurtTimer_timeout():
	udaren_je = false

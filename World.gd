extends Node2D

export var Cam1 = 1000
export var Cam2 = 2100
export var Cam3 = 3500
export var Cam4 = 5000
export var Cam5 = 6750

var vrata_su_vidljiva = false
#CHARACTERI:
const PLAYER = preload("res://Player.tscn")

func _ready():
	GlobalAudio.stop()
#	$ParallaxBackground/ParallaxLayer/Sprite.play("idle")
#	$ParallaxBackground/ParallaxLayer/Sprite3.play("idle")
	global.enemy_metak = false
	$Controls/Joystick.play("idle")
	global.enemy_killed = 0
	if global.player == true:
		$Player2.queue_free()
		$Player3.queue_free()
	if global.playerRED == true:
		$Player.queue_free()
		$Player3.queue_free()
	if global.playerUSA == true:
		$Player.queue_free()
		$Player2.queue_free()			
	global.time = 50
	global.player_lives = 10

func _on_RESTART_pressed():
	get_tree().reload_current_scene()

func _on_QUIT_pressed():
	get_tree().change_scene("res://UI/Menu.tscn")

func _process(delta):
	get_node("Controls/Punch").set_block_signals(false)
	if global.player == true:
	#kamera desno:
		if global.enemy_killed < 4:
			$Player/Camera2D.limit_right = Cam1
		elif global.enemy_killed >= 4 and global.enemy_killed<8:
			$Player/Camera2D.limit_right = Cam2
		elif global.enemy_killed >= 8 and global.enemy_killed<14:
			$Player/Camera2D.limit_right = Cam3
		elif global.enemy_killed >= 14 and global.enemy_killed<21:
			$Player/Camera2D.limit_right = Cam4
		elif global.enemy_killed >= 22 and global.enemy_killed<25:
			$Player/Camera2D.limit_right = Cam5
		#kamera lijevo:
		if $Player.position.x >= Cam1+50:
			#pass
			$Player/Camera2D.limit_left = Cam1
		if $Player.position.x >= Cam2:
			$Player/Camera2D.limit_left = Cam2
		if $Player.position.x >= Cam3:
			$Player/Camera2D.limit_left = Cam3
		if $Player.position.x >= Cam4:
			$Player/Camera2D.limit_left = Cam4
		if $Player.position.x >= Cam5:
			$Player/Camera2D.limit_left = Cam5
			
	elif global.playerRED == true:
	#kamera desno:
		if global.enemy_killed < 4:
			$Player2/Camera2D.limit_right = Cam1
		elif global.enemy_killed >= 4 and global.enemy_killed<8:
			$Player2/Camera2D.limit_right = Cam2
		elif global.enemy_killed >= 8 and global.enemy_killed<13:
			$Player2/Camera2D.limit_right = Cam3
		elif global.enemy_killed >= 13 and global.enemy_killed<19:
			$Player2/Camera2D.limit_right = Cam4
		elif global.enemy_killed >= 19 and global.enemy_killed<20:
			$Player2/Camera2D.limit_right = Cam5
		#kamera lijevo:
		if $Player2.position.x > Cam1+150:
			$Player2/Camera2D.limit_left = Cam1
		if $Player2.position.x > Cam2+150:
			$Player2/Camera2D.limit_left = Cam2
		if $Player2.position.x > Cam3+150:
			$Player2/Camera2D.limit_left = Cam3
		if $Player2.position.x > Cam4+150:
			$Player2/Camera2D.limit_left = Cam4
		if $Player2/Camera2D.limit_left > Cam5+150:
			$Player2/Camera2D.limit_left = Cam5
	elif global.playerUSA == true:
#kamera desno:
		if global.enemy_killed < 4:
			$Player3/Camera2D.limit_right = Cam1
		elif global.enemy_killed >= 4 and global.enemy_killed<8:
			$Player3/Camera2D.limit_right = Cam2
		elif global.enemy_killed >= 8 and global.enemy_killed<13:
			$Player3/Camera2D.limit_right = Cam3
		elif global.enemy_killed >= 13 and global.enemy_killed<19:
			$Player3/Camera2D.limit_right = Cam4
		elif global.enemy_killed >= 19 and global.enemy_killed<20:
			$Player3/Camera2D.limit_right = Cam5
		#kamera lijevo:
		if $Player3.position.x > Cam1+50:
			pass
			#$Player3/Camera2D.limit_left = Cam1
		if $Player3.position.x > Cam2+50:
			$Player3/Camera2D.limit_left = Cam2
		if $Player3.position.x > Cam3+50:
			$Player3/Camera2D.limit_left = Cam3
		if $Player3.position.x > Cam4+50:
			$Player3/Camera2D.limit_left = Cam4
		if $Player3/Camera2D.limit_left > Cam5+50:
			$Player3/Camera2D.limit_left = Cam5
		
func _on_LevelTimer_timeout():
	global.time -= 1
	if global.time <= 0:
		if global.player == true:
			$Player.player_dead()
		elif global.playerRED == true:
			$Player2.player_dead()
		elif global.playerUSA == true:
			$Player3.player_dead()
		

func _on_GameOverArea_body_entered(body):
	if "Player" in body.name:
		#$AudioStreamPlayer2D.stop()
		get_tree().change_scene("res://UI/Menu.tscn")





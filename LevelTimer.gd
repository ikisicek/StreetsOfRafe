extends Area2D

export var broj_ubijenih_enemija = 0
func _on_LevelTimer_body_entered(body):
	if "Player" in body.name:
		global.time = 50
		print ("USAO JE!!!!")
		if global.enemy_killed > broj_ubijenih_enemija:
			global.enemy_killed = broj_ubijenih_enemija

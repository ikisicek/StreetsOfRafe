extends StaticBody2D

var cijela = true
func _ready():
	if cijela == true:
		$Sprite.play("idle")
		z_index =  position.y
func _on_Area2D_area_entered(area):
	if cijela == true:
		if area.is_in_group("playerbullet"):
			$BarrelAudio.play()
			$Sprite.play("boom")
			$AnimationPlayer.play("boom")
			$BoomTimer.start()
			cijela = false
		#$Area2D/CollisionShape2D.disabled = true


func _on_BoomTimer_timeout():
	queue_free()
	

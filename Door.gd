extends Area2D

func _ready():
	$AnimatedSprite.play("lock")
	$AnimatedSprite.z_index = position.y+1

func _on_Door_area_entered(area):
	if area.is_in_group("enemy_stop"):
		$CollisionShape2D.queue_free()
		$AnimatedSprite.play("unlock")
		$AnimatedSprite.z_index = -1
		

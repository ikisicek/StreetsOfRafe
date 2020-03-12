extends Area2D

var otvaraj_vrata = false
func _ready():
	$Sprite.play("idle")

func _on_Area2D_area_entered(area):
	if area.is_in_group("enemy_stop"):
		print("savavdmavkcmkamfckam")
		$Sprite.play("open")


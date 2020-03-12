extends StaticBody2D

export var broj_ubijenih_protivnika = 0

func _ready():
	$Arrow.play("stop")
func _process(delta):
	if global.enemy_killed >= broj_ubijenih_protivnika:
		$CollisionShape2D.disabled = true
		$Sprite.visible=false
		$Arrow.play("go")

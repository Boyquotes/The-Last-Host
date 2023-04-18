extends Control

var tween

var current_ammo : int = 250 : 
	set(value):
		if value < current_ammo:
			$CurrentAmmoClone.text = str(current_ammo)
			$AnimationPlayer.stop()
			$AnimationPlayer.play("floating_ammo")
		else:
			if tween:
				tween.kill()
			tween = create_tween()
			tween.tween_property($CurrentAmmo, "label_settings:font_size", 32, 0.5)
			tween.tween_property($CurrentAmmo, "label_settings:font_size", 24, 0.5)
		
		current_ammo = value
		$CurrentAmmo.text = str(current_ammo)

var max_ammo : int = 250 : 
	set(value):
		max_ammo = value
		$MaxAmmo.text = str(max_ammo)



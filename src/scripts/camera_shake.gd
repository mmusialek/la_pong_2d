extends Camera2D

var shake_intensity: float = 0.0
var shake_decay: float = 5.0

func _process(delta: float) -> void:
	if shake_intensity > 0:
		offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * shake_intensity
		shake_intensity = lerp(shake_intensity, 0.0, shake_decay * delta)
	else:
		offset = Vector2.ZERO

func apply_shake(intensity: float) -> void:
	shake_intensity = intensity

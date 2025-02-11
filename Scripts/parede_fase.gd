extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "JogadorPersonagem":
		if Fases.fase_atual < Fases.fases_maxima:
			Fases.fase_atual += 1
			get_tree().change_scene_to_file("res://Cenas/fase_" + str(Fases.fase_atual) + ".tscn")

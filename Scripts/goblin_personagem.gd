extends "res://Scripts/personagem_base.gd"

@onready var alvo = get_parent().get_node("JogadorPersonagem")

func _physics_process(delta: float) -> void:
	var collider = ataque_ray_cast.get_collider()
	if collider and collider.name == "JogadorPersonagem":
		atacar()
	else:
		if estado_atual == Estado.Normal:
			var direçao = (alvo.position - position).normalized()
			velocity = direçao * velocidade
			look_at(alvo.position)
			rotation = 0
	
	super._physics_process(delta)

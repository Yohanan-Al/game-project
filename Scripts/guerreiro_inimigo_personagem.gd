extends "res://Scripts/personagem_base.gd"

@onready var alvo = get_parent().get_node("JogadorPersonagem")
@onready var vida_progress_bar: ProgressBar = $VidaProgressBar


func _physics_process(delta: float) -> void:
	vida_progress_bar.value = vida / vida_maxima
	
	var collider = ataque_ray_cast.get_collider()
	if collider and collider.name == "JogadorPersonagem":
		if pode_desviar and collider.estado_atual == Estado.Atacando:
			desviar()
		else:
			atacar()
	else:
		if estado_atual == Estado.Normal:
			var direçao = (alvo.position - position).normalized()
			velocity = direçao * velocidade
			look_at(alvo.position)
			rotation = 0
	
	super._physics_process(delta)

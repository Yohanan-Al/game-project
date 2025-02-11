extends "res://Scripts/personagem_base.gd"

# Quando o jogador quer se mover horizontalmente (clica "A" ou "D")
func input_move_horizontal(axis):
	velocidade_alvo.x += axis * velocidade

# Quando o jogador quer se mover verticalmente (clica "W" ou "S")
func input_move_vertical(axis):
	velocidade_alvo.y += axis * velocidade

func _on_corpo_sprite_animation_finished() -> void:
	if estado_atual == Estado.Morrendo:
		get_tree().reload_current_scene()
		return
	super._on_corpo_sprite_animation_finished()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("desviar"):
		desviar()
	
	if Input.is_action_just_pressed("atacar"):
		atacar()
	
	if Input.is_action_pressed("defender"):
		começar_defender()
	else:
		terminar_defender()
	
	if estado_atual == Estado.Normal:
		input_move_horizontal(Input.get_axis("mover_esquerda", "mover_direita"))
		input_move_vertical(Input.get_axis("mover_cima", "mover_baixo"))
	
	super._physics_process(delta)

extends CharacterBody2D

enum Estado {
	Normal,
	Desviando
}

const VELOCIDADE = 300.0
const ACELERAÇAO = VELOCIDADE * 3
const VELOCIDADE_DESVIAR = 400

# Essa é a velocidade que queremos atingir
# "velocity" será interpolado para esse valor conforme o tempo passa
var velocidade_alvo: Vector2

var estado_atual: Estado = Estado.Normal

# Se o personagem desviou para tras porque estava parado
# Usamos isso para fazer o personagem virar para frente de novo depois
var desviou_tras = false

@onready var corpo_sprite: AnimatedSprite2D = $CorpoSprite

# Muda a direçao da animaçao conforme o eixo da velocidade do personagem
func atualizar_rotaçao():
	if velocity.x > 0:
		corpo_sprite.flip_h = false
	elif velocity.x < 0:
		corpo_sprite.flip_h = true

# Muda a animaçao entre parado e correndo conforme a velocidade do personagem
func atualizar_animaçao():
	if velocity.length() > 0:
		corpo_sprite.play("correr")
	else:
		corpo_sprite.play("parado")

# Pega a direçao do personagem de acordo com seu eixo de velocidade
func pegar_direcao():
	var direcao = Vector2()
	if velocity.x > 0:
		direcao.x = 1
	elif velocity.x < 0:
		direcao.x = -1
	if velocity.y > 0:
		direcao.y = 1
	elif velocity.y < 0:
		direcao.y = -1
	return direcao

# Faz o personagem rolar para direçao especificada ou para onde ele esta se movendo
func desviar(direçao = null):
	if estado_atual == Estado.Desviando:
		return
	
	corpo_sprite.play("desviar")
	estado_atual = Estado.Desviando
	if direçao == null:
		direçao = pegar_direcao()
	if direçao.x == 0:
		direçao.x = -1
		desviou_tras = true
	velocity.x = VELOCIDADE_DESVIAR * direçao.x

# Quando o jogador quer se mover horizontalmente (clica "A" ou "D")
func input_move_horizontal(axis):
	velocidade_alvo.x += axis * VELOCIDADE

# Quando o jogador quer se mover verticalmente (clica "W" ou "S")
func input_move_vertical(axis):
	velocidade_alvo.y += axis * VELOCIDADE

func _on_corpo_sprite_animation_finished() -> void:
	if estado_atual == Estado.Desviando:
		velocity.x = 0
		estado_atual = Estado.Normal
		if desviou_tras:
			corpo_sprite.flip_h = false
			desviou_tras = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("desviar"):
		desviar()
	
	if estado_atual == Estado.Normal:
		input_move_horizontal(Input.get_axis("mover_esquerda", "mover_direita"))
		input_move_vertical(Input.get_axis("mover_cima", "mover_baixo"))
		atualizar_animaçao()
		
		velocity = velocity.move_toward(velocidade_alvo, ACELERAÇAO * delta)
		velocidade_alvo = Vector2.ZERO
	
	atualizar_rotaçao()
	move_and_slide()

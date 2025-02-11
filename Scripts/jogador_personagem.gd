extends CharacterBody2D

enum Estado {
	Normal
}

const VELOCIDADE = 300.0
const ACELERAÇAO = VELOCIDADE * 3

# Essa é a velocidade que queremos atingir
# "velocity" será interpolado para esse valor conforme o tempo passa
# Essa velocidade é resetada no fim de cada frame
var velocidade_alvo: Vector2

var estado_atual: Estado = Estado.Normal

@onready var corpo_sprite: AnimatedSprite2D = $CorpoSprite

# Muda a direçao da animaçao conforme a entrada do usuario
# Muda a animaçao entre parado e correndo conforme a velocidade do personagem
func atualizar_animaçao():
	if velocity.x > 0:
		corpo_sprite.flip_h = false
	elif velocity.x < 0:
		corpo_sprite.flip_h = true
	
	if velocity.length() > 0:
		corpo_sprite.play("correr")
	else:
		corpo_sprite.play("parado")

# Quando o jogador quer se mover horizontalmente (clica "A" ou "D")
func input_move_horizontal(axis):
	velocidade_alvo.x += axis * VELOCIDADE

# Quando o jogador quer se mover verticalmente (clica "W" ou "S")
func input_move_vertical(axis):
	velocidade_alvo.y += axis * VELOCIDADE

func _physics_process(delta: float) -> void:
	if estado_atual == Estado.Normal:
		input_move_horizontal(Input.get_axis("mover_esquerda", "mover_direita"))
		input_move_vertical(Input.get_axis("mover_cima", "mover_baixo"))
		atualizar_animaçao()

	velocity = velocity.move_toward(velocidade_alvo, ACELERAÇAO * delta)
	move_and_slide()
	velocidade_alvo = Vector2.ZERO

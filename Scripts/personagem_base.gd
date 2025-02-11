extends CharacterBody2D

enum Estado {
	Normal,
	Desviando,
	Atacando,
	Defendendo,
	Morrendo,
	ParaVoltarNormal
}

@export var vida: float = 20
@export var vida_maxima: float = 20

@export var velocidade = 300.0
@onready var ACELERAÇAO = velocidade * 3
@export var velocidade_desviar = 400
@export var dano = 5
@export var defesa = 5

# Essa é a velocidade que queremos atingir
# "velocity" será interpolado para esse valor conforme o tempo passa
var velocidade_alvo: Vector2

var estado_atual: Estado = Estado.Normal

# Se o personagem desviou para tras porque estava parado
# Usamos isso para fazer o personagem virar para frente de novo depois
var desviou_tras = false

@onready var corpo_sprite: AnimatedSprite2D = $CorpoSprite
@onready var ataque_ray_cast: RayCast2D = $AtaqueRayCast
var ataque_ray_cast_length: float

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
	if estado_atual != Estado.Normal:
		return
	
	corpo_sprite.play("desviar")
	estado_atual = Estado.Desviando
	if direçao == null:
		direçao = pegar_direcao()
	if direçao.x == 0:
		direçao.x = -1
		desviou_tras = true
	velocity.x = velocidade_desviar * direçao.x

func atacar():
	if estado_atual != Estado.Normal:
		return
	print("atacar")
	corpo_sprite.play("atacar")
	estado_atual = Estado.Atacando
	velocity = Vector2.ZERO

func levar_dano(dano, node):
	if estado_atual == Estado.Morrendo:
		return
	if estado_atual == Estado.Defendendo:
		corpo_sprite.play("bloqueado")
		# Só defende se o alvo estiver em nossa frente
		if (not corpo_sprite.flip_h and node.position.x > position.x) or (corpo_sprite.flip_h and position.x > node.position.x):
			dano /= defesa
	else:
		corpo_sprite.play("sofrer")
		estado_atual = Estado.ParaVoltarNormal
	vida -= dano
	if vida <= 0:
		corpo_sprite.play("morrer")
		estado_atual = Estado.Morrendo
		velocity = Vector2.ZERO

func começar_defender():
	if estado_atual != Estado.Normal:
		return
	
	corpo_sprite.play("defender")
	estado_atual = Estado.Defendendo
	velocity = Vector2.ZERO

func terminar_defender():
	if estado_atual != Estado.Defendendo:
		return
	
	estado_atual = Estado.Normal

func _on_corpo_sprite_animation_finished() -> void:
	match estado_atual:
		Estado.Desviando:
			velocity.x = 0
			estado_atual = Estado.Normal
			if desviou_tras:
				corpo_sprite.flip_h = false
				desviou_tras = false
		Estado.Atacando:
			var collider = ataque_ray_cast.get_collider()
			if collider and "levar_dano" in collider:
				collider.levar_dano(dano, self)
			estado_atual = Estado.Normal
		Estado.Defendendo:
			if corpo_sprite.animation == "bloqueado":
				corpo_sprite.play("defender")
		Estado.Morrendo:
			queue_free()
		Estado.ParaVoltarNormal:
			estado_atual = Estado.Normal

func _ready():
	corpo_sprite.connect("animation_finished", _on_corpo_sprite_animation_finished)
	ataque_ray_cast_length = ataque_ray_cast.target_position.x

func _physics_process(delta: float) -> void:
	if estado_atual == Estado.Normal:
		atualizar_animaçao()
		
		velocity = velocity.move_toward(velocidade_alvo, ACELERAÇAO * delta)
		velocidade_alvo = Vector2.ZERO
	
	atualizar_rotaçao()
	ataque_ray_cast.target_position.x = ataque_ray_cast_length * (-1 if corpo_sprite.flip_h else 1)
	move_and_slide()

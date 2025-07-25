extends Area2D

@export var velocidad := 150
@export var altura_maxima := 100.0
var posicion_inicial := Vector2.ZERO

func _ready():
    posicion_inicial = position
    await get_tree().create_timer(3.0).timeout
    queue_free()

func _process(delta):
    if position.y > posicion_inicial.y - altura_maxima:
        position.y -= velocidad * delta


func _on_body_entered(body):
    if body.is_in_group("jugador") and body.has_method("aplicar_danio"):
        body.aplicar_danio(10)
        print("🌳 Árbol dañó al jugador")

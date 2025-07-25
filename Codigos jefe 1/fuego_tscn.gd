extends Area2D

@export var velocidad := 300
@export var tiempo_vida := 3.0

func _ready():
    # Destruir después de cierto tiempo
    await get_tree().create_timer(tiempo_vida).timeout
    queue_free()

func _process(delta):
    position.y += velocidad * delta

func _on_body_entered(body):
    if body.is_in_group("jugador") and body.has_method("aplicar_danio"):
        body.aplicar_danio(10)
        print("🔥 El fuego dañó al jugador")

extends Area2D

func _on_body_entered(body):
    if body.has_method("aplicar_danio"):
        body.aplicar_danio(10)

        print("💥 Golpe del brazo dañó al jugador")

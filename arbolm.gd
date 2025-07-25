extends Area2D


func _on_body_entered(body):
    if body.is_in_group("jugador"):
        print("Jugador tocó fuego, aplicando daño")
        body.aplicar_danio(10)

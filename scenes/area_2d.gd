extends Area2D

func _on_body_entered(body: Node2D) -> void:
    if body.has_method("aplicar_danio"):
        body.aplicar_danio(10)

extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@export var bullet_node: PackedScene
var health := 100

func _physics_process(_delta):
    velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * 250
    move_and_slide()

    # Animaciones
    if velocity.y < -10:
        animated_sprite.flip_v = false
        animated_sprite.play("subir")
    elif velocity.y > 10:
        animated_sprite.flip_v = true
        animated_sprite.play("subir") # Reutilizamos la misma animación
    elif velocity.length() > 0:
        animated_sprite.flip_v = false
        animated_sprite.play("nadar")
    else:
        animated_sprite.stop()

    # Flip horizontal (izquierda/derecha)
    if velocity.x < 0:
        animated_sprite.flip_h = true
    elif velocity.x > 0:
        animated_sprite.flip_h = false

func shoot():
    var bullet = bullet_node.instantiate()
    bullet.position = global_position
    bullet.direction = (get_global_mouse_position() - global_position).normalized()
    get_tree().current_scene.call_deferred("add_child", bullet)

func _input(event):
    if event.is_action("shoot"):
        shoot()

func aplicar_danio(cantidad):
    health -= cantidad
    print("⚠️ Jugador recibió", cantidad, "de daño. Vida:", health)
    if health <= 0:
        queue_free()

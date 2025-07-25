extends CharacterBody2D

@export var velocidad := 400
@export var fuerza_salto := 477
@export var gravedad := 1250
@export var vida := 100

@onready var anim = $AnimatedSprite2D

var atacando := false

func _physics_process(delta):
    var direccion := 0.0

    if Input.is_action_pressed("ui_left"):
        direccion -= 1
    if Input.is_action_pressed("ui_right"):
        direccion += 1

    velocity.x = direccion * velocidad

    if not is_on_floor():
        velocity.y += gravedad * delta
    elif Input.is_action_just_pressed("salto"):
        velocity.y = -fuerza_salto
        anim.play("saltar")

    move_and_slide()

    # Flip horizontal
    if direccion != 0:
        anim.flip_h = direccion < 0

    # Animaciones
    if atacando:
        anim.play("atacar")
    elif not is_on_floor():
        anim.play("saltar")
    elif direccion != 0:
        anim.play("correr")
    else:
        anim.play("idle")

    # Ataque
    if Input.is_action_just_pressed("ataque") and not atacando:
        atacando = true
        anim.play("atacar")
        detectar_y_atacar()
        await anim.animation_finished
        atacando = false

func detectar_y_atacar():
    var area := RectangleShape2D.new()
    area.extents = Vector2(180, 30)
    
    var direccion := -1 if $AnimatedSprite2D.flip_h else 1
    var transform := Transform2D(0, global_position + Vector2(30 * direccion, 0))

    var query := PhysicsShapeQueryParameters2D.new()
    query.shape = area
    query.transform = transform
    query.collide_with_areas = true
    query.collide_with_bodies = true

    var space := get_world_2d().direct_space_state
    var resultado := space.intersect_shape(query)

    for hit in resultado:
        var obj = hit.get("collider")
        if obj and obj.has_method("aplicar_danio") and obj != self:
            print("💥 Golpeó a:", obj)
            obj.aplicar_danio(10)

func aplicar_danio(cantidad):
    vida -= cantidad
    print("⚠️ Jugador recibió", cantidad, "de daño. Vida:", vida)
    if vida <= 0:
        morir()

func morir():
    print("💀 El jugador ha muerto")
    queue_free()

extends Area2D

@onready var progress_bar =$CanvasLayer/ProgressBar
@export var vida := 100
var fuego_escena := preload("res://fuego_tscn.tscn")
var arbol_escena := preload("res://arbol.tscn")
var vivo := true

func _ready():
    start_pattern()

func aplicar_danio(cantidad):
    if not vivo:
        return
    vida -= cantidad
    print("☠️ Jefe recibió daño. Vida restante:", vida)
    if vida <= 0:
        morir()

func morir():
    print("💀 ¡El jefe ha muerto!")
    queue_free()

func lanzar_fuego():
    for spawn in $FuegoSpawns.get_children():
        var fuego = fuego_escena.instantiate()
        fuego.global_position = spawn.global_position
        get_tree().current_scene.add_child(fuego)

func brotar_arboles():
    for i in range(1):
        for spawn in $ArbolSpawns.get_children():
            var arbol = arbol_escena.instantiate()
            arbol.global_position = spawn.global_position
            get_tree().current_scene.add_child(arbol)
        await get_tree().create_timer(1.5).timeout

func start_pattern():
    print("🔥 Fuego")
    $AnimationPlayer.play("golpe_brazo")
    await $AnimationPlayer.animation_finished
    lanzar_fuego()
    await get_tree().create_timer(2).timeout

    print("🌳 Árboles")
    await brotar_arboles()
    await get_tree().create_timer(3).timeout



    start_pattern()

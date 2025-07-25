extends CharacterBody2D

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree["parameters/playback"]

const melee_attacks = ["attack_1", "attack_2","attack_3"]
const range_attacks = ["jump_up","throw"]

@export var player: CharacterBody2D

var p0: Vector2
var p1: Vector2 
var p2: Vector2

var t: float = 1
var speed: float = 2.0

func _ready():
    state_machine.travel("jump_up")
    
func _physics_process(delta):
    if t < 1.0:
        t += speed * delta
        position = position.bezier_interpolate(p0,p1,p2,t)
        
func jump():
    t = 0
    speed = 2.0

func melee_attack():
    state_machine.travel(melee_attacks.pick_random())
    
func range_attack():
    await get_tree().create_timer(0.1).timeout
    state_machine.travel(range_attacks.pick_random())   

func can_do_special():
    var chance = randf()
    animation_tree["parameters/conditions/can_dodge"] = chance < 0.5
    
func set_destination(final_position):
    p0 = global_position
    p2 = final_position
    
    var angle
    if (p2-p0).x < 0:
        angle = 60
        
    else:
        angle = -60
        
    var tilted_unit_vector = (p2-p0).normalized().rotated(deg_to_rad(angle))
    p1 = p0 + 90 * tilted_unit_vector

class_name Robot3 extends QuadEntity

var health : Health = Health.new()
@onready var health_bar = $robot3/ProgressBar
@onready var cloudy_explosion = $cloudy_explosion
@onready var robot_3 = $robot3
@onready var death_timer = $DeathTimer

var dead = false

func _ready():
	super._ready()

	health.health_changed.connect(_on_health_changed)
	health.die.connect(_on_death)
	death_timer.timeout.connect(queue_free)

func _on_health_changed(cur, max_h) -> void:
	health_bar.ratio = cur/max_h

func _on_death() -> void:
	if dead:
		return
	robot_3.hide()
	cloudy_explosion.emitting = true
	death_timer.start()
	dead = true

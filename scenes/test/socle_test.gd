extends Control
@onready var socle: Node3D = $MainViewport/SubViewport/socle

@onready var simple_bot_button = $CanvasLayer/LeftContainer/SimpleBotButton
@onready var small_bot_button = $CanvasLayer/LeftContainer/SmallBotButton
@onready var healer_bot_button = $CanvasLayer/LeftContainer/HealerBotButton
@onready var simple_robot = $MainViewport/SubViewport/socle/SimpleRobot
@onready var small_bot = $MainViewport/SubViewport/socle/robot3
@onready var healer_bot = $MainViewport/SubViewport/socle/robot2

func _ready() -> void:
	simple_bot_button.pressed.connect(_on_simple_bot_button_pressed)
	small_bot_button.pressed.connect(_on_small_bot_button_pressed)
	healer_bot_button.pressed.connect(_on_healer_bot_button_pressed)

func hide_all_bot() -> void:
	simple_robot.hide()
	small_bot.hide()
	healer_bot.hide()

func show_bot(bot : IKQuadObject) -> void:
	bot.show()
	bot.apply_force(Vector3(2,0,0), 10.)

func _on_simple_bot_button_pressed() -> void:
	hide_all_bot()
	show_bot(simple_robot)

func _on_small_bot_button_pressed() -> void:
	hide_all_bot()
	show_bot(small_bot)

func _on_healer_bot_button_pressed() -> void:
	hide_all_bot()
	show_bot(healer_bot)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			socle.rotate_y(0.1)
		if mouse_event.button_index == MOUSE_BUTTON_WHEEL_UP:
			socle.rotate_y(-0.1)
	if event is InputEventKey and event.keycode == KEY_P and event.is_pressed():
		$CanvasLayer2/SubViewport.get_texture().get_image().save_png("res://screenshot.png")
	if event is InputEventKey and event.keycode == KEY_DOWN and event.is_pressed():
		$CanvasLayer/CircleSlidingContainer.spin(true)
	if event is InputEventKey and event.keycode == KEY_UP and event.is_pressed():
		$CanvasLayer/CircleSlidingContainer.spin(false)

func _process(delta) -> void:
	socle.rotate_y(-0.1*delta)

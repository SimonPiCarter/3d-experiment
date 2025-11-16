class_name Health extends Resource

@export var maxHealth : float = 10.
@export var currentHealth : float = 10.

signal health_changed(cur : float, max: float)
signal die

func damage(amount : float):
	currentHealth = clamp(currentHealth - amount, 0., maxHealth)
	health_changed.emit(currentHealth, maxHealth)
	if currentHealth <= 0.:
		die.emit()

func heal(amount : float):
	currentHealth = clamp(currentHealth + amount, 0., maxHealth)
	health_changed.emit(currentHealth, maxHealth)

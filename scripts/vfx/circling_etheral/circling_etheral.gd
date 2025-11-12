extends TwoSegmentObject

@export var radius : float = 5.
@export var speed : float = 90.
@export var path : PathFollow3D = null
@export var distance : float = 0.5

@onready var anchor_dynamic = $AnchorDynamic

func _ready():
	for anchor in self.segments:
		anchor.max_distance = distance + 0.1
		anchor.min_distance = distance

var cur_progress = 0.
func _process(delta):
	if not path:
		cur_progress += speed * deg_to_rad(delta)
		#anchor_dynamic.anchor_1.position.x = radius * cos(cur_progress)
		anchor_dynamic.anchor_1.position.z = radius * sin(cur_progress)
		anchor_dynamic.anchor_1.position.y = radius * cos(cur_progress)
	else:
		cur_progress += speed * delta
		path.progress_ratio = cur_progress / 100.
		anchor_dynamic.anchor_1.position = path.position

	super._process(delta)

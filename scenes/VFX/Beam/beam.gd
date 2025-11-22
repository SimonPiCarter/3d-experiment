extends Node3D

func start():
	$AnimationTree.done = false

func stop():
	$AnimationTree.done = true

func switch():
	$AnimationTree.done = not $AnimationTree.done

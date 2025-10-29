@tool
extends Node3D

@export_tool_button("fire") var fire_action = fire

func fire():
	$MainBeam.emitting = true
	$SmallBeam.emitting = true
	$Splash.emitting = true

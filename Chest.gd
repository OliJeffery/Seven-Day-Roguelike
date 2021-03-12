extends Node2D

var rng = RandomNumberGenerator.new()

func open():
	$StaticBody2D/AnimationPlayer.play("Open chest")

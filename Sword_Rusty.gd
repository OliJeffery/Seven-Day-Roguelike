extends Node2D


func attack():
	print('SWINGING RUSTY SWORD')
	$KinematicBody2D/AnimationPlayer.play("Swing sword")

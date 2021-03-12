extends Node2D


func attack():
	$KinematicBody2D/AnimationPlayer.play("Swing sword")

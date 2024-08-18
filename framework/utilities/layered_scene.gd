class_name LayeredScene
extends RefCounted



var scenes : Array[Node] = []
var current : int = -1:
	set(value):
		current = value

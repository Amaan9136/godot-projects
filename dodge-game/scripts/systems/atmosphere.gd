extends Node

const Stage = preload("res://scripts/utils/stage.gd")
const CRT_SHADER: Shader = preload("res://assets/shaders/crt.gdshader")


func _ready() -> void:
	_make_layer(-10).add_child(Stage.new())
	var shader_material := ShaderMaterial.new()
	shader_material.shader = CRT_SHADER
	var overlay := ColorRect.new()
	overlay.material = shader_material
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_make_layer(90).add_child(overlay)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)


func _make_layer(order: int) -> CanvasLayer:
	var canvas := CanvasLayer.new()
	canvas.layer = order
	add_child(canvas)
	return canvas

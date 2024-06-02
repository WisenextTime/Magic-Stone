extends TextureButton
var _pressed=false
var _index=-1
var indexPosition=0

func _input(event):
	if _pressed and _index==-1:
		if event is InputEventScreenTouch:
			_index=event.index
	if event is InputEventScreenDrag and event.index==_index:
		indexPosition=event.position.y


func _on_button_up():
	_pressed=false
	_index=-1
	$"..".modulate.a=0.2

func _on_button_down():
	_pressed=true
	$"..".modulate.a=1
	
func _physics_process(_delta):
	if pressed:
		if indexPosition>$"../bar".global_position.y:
			global_position.y=min(indexPosition,$"../bar".global_position.y+192.0)-48.0
		else:
			global_position.y=max(indexPosition,$"../bar".global_position.y-192.0)-48.0
		$"../../../camera".zoom=Vector2.ONE*((global_position.y+48-$"../bar".global_position.y-192)/-384+1)


extends Node2D
var s_id=null
@export var res:data_tiled
var _type
var _name
var _id
var _img

func _ready():
	if s_id != null:
		res=ResourceLoader.load("user://data/tileds/%s.tres"%s_id)
	_load()


func _load():
	_type=res.t_type
	_name=res.t_name
	_id=res.t_id
	_img=res.t_img
	$image.texture=ImageTexture.create_from_image(Image.load_from_file(_img))
	if _type=="road":
		$void.avoidance_enabled=false
		$road.enabled=true
	else:
		$road.enabled=false
		$void.avoidance_enabled=true

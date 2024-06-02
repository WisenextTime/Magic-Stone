extends Node2D
var s_id=null
@export var res:data_building
var _type
var _name
var _description
var _id
var _img
var _maxhp
var _enemy:=[]
var par

func _ready():
	if s_id != null:
		res=ResourceLoader.load("user://data/buildings/%s.tres"%s_id)
	_load()


func _load():
	_type=res.b_type
	_name=res.b_name
	_id=res.b_id
	_description=res.b_description
	_maxhp=res.b_maxhp
	_img=res.b_img
	par.g_hp+=_maxhp
	$image.texture_normal=ImageTexture.create_from_image(Image.load_from_file(_img))


func _on_image_pressed():
	par.now_target=self

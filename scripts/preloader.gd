extends Node2D
@export var tiled_pre:data_tiled
@export var building_pre:data_building
@export var enemy_pre:data_enemy
@export var turret_pre:data_turret
@export var weapon_pre:data_weapon

func _ready():
	$light.rotation=0
	_prepare()
	_index_pre()

func _prepare():
	$text.text="正在初始化文件夹"
	if not DirAccess.dir_exists_absolute("user://data"):
		DirAccess.make_dir_absolute("user://data")
	var data = DirAccess.open("user://data")
	if not data.dir_exists("tileds"):
		data.make_dir("tileds")
	if not data.dir_exists("buildings"):
		data.make_dir("buildings")
	if not data.dir_exists("turrets"):
		data.make_dir("turrets")
	if not data.dir_exists("enemies"):
		data.make_dir("enemies")
	if not data.dir_exists("maps"):
		data.make_dir("maps")
	if not data.dir_exists("status"):
		data.make_dir("status")
	if not data.dir_exists("weapons"):
		data.make_dir("weapons")
	if not data.dir_exists("effects"):
		data.make_dir("effects")
	dir_remove_all("user://data/tileds")
	dir_remove_all("user://data/buildings")
	dir_remove_all("user://data/turrets")
	dir_remove_all("user://data/enemies")
	dir_remove_all("user://data/maps")
	dir_remove_all("user://data/status")
	dir_remove_all("user://data/weapons")
	dir_remove_all("user://data/effects")

func _index_pre():
	$text.text+="\n初始化地块资源"
	_pre_index_tiled()
	$text.text+="\n初始化建筑资源"
	_pre_index_building()
	$text.text+="\n初始化敌人数据"
	_pre_index_enemy()
	$text.text+="\n初始化炮塔和武器数据"
	_pre_index_turret()
	_pre_index_weapon()
	$text.text+="\n完成！"
	
func _physics_process(_delta):
	$light.rotation+=0.1

func dir_remove_all(dir_name):
	var dir = DirAccess.open(dir_name)
	var files=DirAccess.get_files_at(dir_name)
	for file in files:
		dir.remove(file)
	
func _pre_index_tiled():
	var config=ConfigFile.new()
	config.load("res://assets/main/code/tileds.cfg")
	var img_dir=DirAccess.open("res://assets/main/img/tileds")
	for id in config.get_sections():
		var _tiled_name=config.get_value(id,"name")
		var _tiled_type=config.get_value(id,"type")
		var _tiled_image=config.get_value(id,"image")
		tiled_pre.t_id=id
		tiled_pre.t_name=_tiled_name
		tiled_pre.t_type=_tiled_type
		if img_dir.file_exists(_tiled_image):
			img_dir.copy("res://assets/main/img/tileds/%s"%_tiled_image,"user://data/tileds/%s"%_tiled_image)
			tiled_pre.t_img=("user://data/tileds/%s"%_tiled_image)
		else:
			tiled_pre.t_img="res://assets/no_image.png"
		ResourceSaver.save(tiled_pre,"user://data/tileds/%s.tres"%id)
		
func _pre_index_building():
	var config=ConfigFile.new()
	config.load("res://assets/main/code/buildings.cfg")
	var img_dir=DirAccess.open("res://assets/main/img/buildings")
	for id in config.get_sections():
		var _building_name=config.get_value(id,"name")
		var _building_type=config.get_value(id,"type")
		var _building_image=config.get_value(id,"image")
		var _building_description=config.get_value(id,"description")
		var _building_maxhp=config.get_value(id,"maxhp",0)
		building_pre.b_id=id
		building_pre.b_name=_building_name
		building_pre.b_type=_building_type
		building_pre.b_description=_building_description
		building_pre.b_maxhp=_building_maxhp
		if img_dir.file_exists(_building_image):
			img_dir.copy("res://assets/main/img/buildings/%s"%_building_image,"user://data/buildings/%s"%_building_image)
			building_pre.b_img=("user://data/buildings/%s"%_building_image)
		else:
			building_pre.b_img="res://assets/no_image.png"
		ResourceSaver.save(building_pre,"user://data/buildings/%s.tres"%id)

func _pre_index_enemy():
	var config=ConfigFile.new()
	config.load("res://assets/main/code/enemys.cfg")
	var img_dir=DirAccess.open("res://assets/main/img/enemys")
	for id in config.get_sections():
		var _enemy_name=config.get_value(id,"name")
		var _enemy_description=config.get_value(id,"description")
		var _enemy_movetype=config.get_value(id,"movetype")
		var _enemy_image=config.get_value(id,"image")
		var _enemy_hp=config.get_value(id,"hp")
		var _enemy_shield=config.get_value(id,"shield")
		var _enemy_armor=config.get_value(id,"armor")
		var _enemy_attack=config.get_value(id,"attack")
		var _enemy_speed=config.get_value(id,"speed")
		enemy_pre.e_id=id
		enemy_pre.e_name=_enemy_name
		enemy_pre.e_movetype=_enemy_movetype
		enemy_pre.e_hp=_enemy_hp
		enemy_pre.e_shield=_enemy_shield
		enemy_pre.e_armor=_enemy_armor
		enemy_pre.e_description=_enemy_description
		enemy_pre.e_speed=_enemy_speed
		enemy_pre.e_attack=_enemy_attack
		if img_dir.file_exists(_enemy_image):
			img_dir.copy("res://assets/main/img/enemys/%s"%_enemy_image,"user://data/enemies/%s"%_enemy_image)
			enemy_pre.e_img=("user://data/enemies/%s"%_enemy_image)
		else:
			enemy_pre.e_img="res://assets/no_image.png"
		ResourceSaver.save(enemy_pre,"user://data/enemies/%s.tres"%id)
		
func _pre_index_turret():
	var config=ConfigFile.new()
	config.load("res://assets/main/code/turrets.cfg")
	var img_dir=DirAccess.open("res://assets/main/img/turrets")
	for id in config.get_sections():
		var _turret_name=config.get_value(id,"name")
		var _turret_type=config.get_value(id,"type")
		var _turret_image=config.get_value(id,"image")
		var _turret_description=config.get_value(id,"description")
		var _turret_price=config.get_value(id,"price")
		var _turret_weapon=config.get_value(id,"weapon")
		turret_pre.t_id=id
		turret_pre.t_name=_turret_name
		turret_pre.t_type=_turret_type
		turret_pre.t_description=_turret_description
		turret_pre.t_weapon=_turret_weapon
		turret_pre.t_price=_turret_price
		if img_dir.file_exists(_turret_image):
			img_dir.copy("res://assets/main/img/turrets/%s"%_turret_image,"user://data/tileds/%s"%_turret_image)
			turret_pre.t_img=("user://data/tileds/%s"%_turret_image)
		else:
			turret_pre.t_img="res://assets/no_image.png"
		ResourceSaver.save(turret_pre,"user://data/turrets/%s.tres"%id)

func _pre_index_weapon():
	var config=ConfigFile.new()
	config.load("res://assets/main/code/weapons.cfg")
	var img_dir=DirAccess.open("res://assets/main/img/weapons")
	for id in config.get_sections():
		var _weapon_name=config.get_value(id,"name")
		var _weapon_bullet=config.get_value(id,"bullet")
		var _weapon_image=config.get_value(id,"image")
		weapon_pre.w_id=id
		weapon_pre.w_name=_weapon_name
		weapon_pre.w_bullet=_weapon_bullet
		if img_dir.file_exists(_weapon_image):
			img_dir.copy("res://assets/main/img/weapons/%s"%_weapon_image,"user://data/weapons/%s"%_weapon_image)
			weapon_pre.w_img=("user://data/weapons/%s"%_weapon_image)
		else:
			weapon_pre.w_img="res://assets/no_image.png"
		ResourceSaver.save(weapon_pre,"user://data/weapons/%s.tres"%id)

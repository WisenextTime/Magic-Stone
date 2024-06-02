extends Control

var map = "res://assets/main/maps/test.zip"
var m_info
var m_tileds
var m_buildings
var m_img=load("res://assets/map_no_view.png")
var t_contains:=[]
var b_contains:={}
var i_name
var i_description="none"
var i_author="Unknown"
var i_width
var i_height

var g_hp=0
var g_wave=0
var g_coin=0

var start_pos:Vector2
var ins_tiled=preload("res://scenes/tiled.tscn")
var ins_building=preload("res://scenes/building.tscn")
var c_relative=Vector2.ZERO

var zoom_pressed=false

var now_target=null

func _ready():
	var err= _maploader()
	if err==0:
		err=_mapcheck()
		if err==0:
			_drawmap()
	
func _maploader():
	var file:=ZIPReader.new()
	file.open(map)
	if not file.file_exists("info.ini"):
		return "无效的地图文件，缺少信息文件"
	elif not file.file_exists("tileds.cfg"):
		return "无效的地图文件，缺少地块数据文件"
	elif not file.file_exists("buildings.cfg"):
		return "无效的地图文件，缺少建筑数据文件"
	else:
		m_info=file.read_file("info.ini")
		m_tileds=file.read_file("tileds.cfg")
		m_buildings=file.read_file("buildings.cfg")
		if file.file_exists("view.png"):
			m_img=file.read_file("view.png")
		return 0

func _mapcheck():
	#检测info.ini
	var tileds=ConfigFile.new()
	tileds.parse(m_info.get_string_from_utf8())
	if not tileds.has_section("map"):
		return "无效的地图信息文件，info.ini未包含map节"
	if not tileds.has_section_key("map","name"):
		return "无效的地图文件，未能找到地图名称"
	if not tileds.has_section_key("map","width"):
		return "无效的地图文件，未能找到地图宽度"
	if not tileds.has_section_key("map","height"):
		return "无效的地图文件，未能找到地图高度"
	i_width=tileds.get_value("map","width")-1
	i_height=tileds.get_value("map","height")-1
	tileds.clear()
	#检测tileds.cfg
	tileds.parse(m_tileds.get_string_from_utf8())
	if not tileds.has_section("tileds"):
		return "无效的地图信息文件，tileds.cfg未包含tileds节"
	t_contains=tileds.get_value("tileds","contains")
	if t_contains.size()!=(i_width+1)*(i_height+1):
		return "无效的地图文件，地块多余或缺失"
	tileds.clear()
	#检测buildings.cfg
	tileds.parse(m_buildings.get_string_from_utf8())
	for build in tileds.get_sections():
		var contain={}
		contain["wave"]=0
		if build.begins_with("core"):
			contain["id"]=tileds.get_value(build,"id")
			contain["pos"]=tileds.get_value(build,"pos")
		elif build.begins_with("entrance"):
			contain["id"]=tileds.get_value(build,"id")
			contain["pos"]=tileds.get_value(build,"pos")
			contain["wave"]=tileds.get_value(build,"wave",0)
			contain["contains"]=tileds.get_value(build,"contains")
		else:
			contain["id"]=tileds.get_value(build,"id")
			contain["pos"]=tileds.get_value(build,"pos")
		b_contains[build]=contain
	return 0

func _drawmap():
	g_hp=0
	#绘制地块
	start_pos=Vector2(-int((i_width+1)/2)*32,-int((i_height+1)/2)*32)
	for _y in range(int(i_height)+1):
		for _x in range(int(i_width)+1):
			var now_ins=ins_tiled.instantiate()
			now_ins.global_position=Vector2(start_pos.x+_x*32,start_pos.y+_y*32)
			now_ins.s_id=t_contains[_y*(i_width+1)+_x]
			get_tree().root.add_child.call_deferred(now_ins)
	#绘制建筑
	for building in b_contains:
		g_wave=g_wave if g_wave>b_contains[building].wave else b_contains[building].wave
		var now_ins=ins_building.instantiate()
		now_ins.global_position=Vector2(start_pos.x+(b_contains[building].pos.x-1)*32,start_pos.y+(b_contains[building].pos.y-1)*32)
		if building.begins_with("entrance"):
			now_ins._enemy=b_contains[building].contains.duplicate()
		now_ins.s_id=b_contains[building].id
		now_ins.par=self
		get_tree().root.add_child.call_deferred(now_ins)

func _unhandled_input(event):
	if event is InputEventScreenDrag:
		$camera.position+=-event.relative/$camera.zoom.x
	if event is InputEventScreenTouch:
		if event.double_tap:
			$camera.global_position=Vector2.ZERO
		else:
			now_target=null

func _physics_process(_delta):
	if now_target==null:
		$UI/setting.visible=false
	else:
		$UI/setting.visible=true
	var fps=Engine.get_frames_per_second()
	var fps_viewer=$UI/menubar/info_FPS/FPS
	fps_viewer.text="FPS:"+str(fps)
	fps_viewer.modulate=Color.GREEN if fps>54 else (Color.RED if fps<48 else Color.YELLOW)
	$UI/menubar/hpbar/Hbox/hp.text=str(g_hp)
	$UI/menubar/coinbar/Hbox/coin.text=str(g_coin)

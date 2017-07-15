extends Node2D

var npc_dialogue = {}
var talk_data = {}
var debug

onready var dialog_panel = load("res://asset scenes/dialogue_window.tscn")
onready var reply_button = load("res://asset scenes/reply.tscn")

onready var viewsize = get_viewport().get_rect().size
var dialog = {"width": 1000, "height": 60, "posx": 500, "posy": 370}

var num_replies
var npc_name
var talk_anim

func _ready():
	set_process(true)
	set_fixed_process(true)
	set_process_input(true)
	
	for object in get_node("npcs").get_children():
		object.connect("dialogue", self, "_talk_to")

func _talk_to(dialogue, branch, name):
	npc_dialogue = {"name": name,"dialogue": dialogue, "branch": branch}
	start_dialogue(npc_dialogue)

func _pick_reply(n):
	if talk_data["dialogue"][npc_dialogue["branch"]]["responses"][n]["next"] != "exit":
		npc_dialogue["branch"] = talk_data["dialogue"][npc_dialogue["branch"]]["responses"][n]["next"]
		start_dialogue(npc_dialogue)
	else:
		kill_dialogue()
	
func start_dialogue(json):
	load_json(json, "dialogue")
	npc_name = talk_data["name"]
	talk_anim = talk_data["animation"]
	print(npc_name)
	print(talk_anim)
	num_replies = talk_data["dialogue"][npc_dialogue["branch"]]["responses"].size()
	
	#setup dialog window
	setup_dialogue_window()
	
	#set text and reply in dialogue panel
	get_node("ui_dialogue/dialogue/name").set_text(npc_name)
	get_node("ui_dialogue/dialogue").set_text(talk_data["dialogue"][npc_dialogue["branch"]]["text"])
	for n in range(0,num_replies):

		get_node("ui_dialogue/reply" + str(n+1)).set_text(talk_data["dialogue"][npc_dialogue["branch"]]["responses"][n]["reply"])
		
func load_json(json, type):
	var file = File.new();
	file.open(json["dialogue"], File.READ);
	talk_data.parse_json(file.get_as_text())
	file.close()
	debug = json

func setup_dialogue_window():
		
	var reply_offset = 0
	var labels = ["panel","dialogue"]
	
	#add one element "reply" per number of replies in talk_data
	for n in range(num_replies):
		labels.push_back("reply" + str(n+1))
		
	create_labels(labels)
	
	get_node("ui_dialogue/panel").set_size(Vector2(dialog.width, dialog.height + num_replies*30))
	get_node("ui_dialogue/panel").set_pos(Vector2(viewsize.x/2 - dialog.width/2, viewsize.y - dialog.posy))
	get_node("ui_dialogue/panel").set_opacity(0.5)
	
	get_node("ui_dialogue/dialogue").set_size(Vector2(dialog.width -20, dialog.height + num_replies*30))
	get_node("ui_dialogue/dialogue").set_pos(Vector2(viewsize.x/2 + 100 - dialog.width/2, viewsize.y - dialog.posy + 20))
	
	for n in range(num_replies):
		get_node("ui_dialogue/reply" + str(n+1)).set_size(Vector2(400, 50))
		get_node("ui_dialogue/reply" + str(n+1)).set_pos(Vector2(viewsize.x/2 +100 - dialog.width/2, viewsize.y - 300 + reply_offset))
		get_node("ui_dialogue/reply" + str(n+1)).num_reply = n
		reply_offset += 30
	
	talk_anim = load("res://asset scenes/" + npc_name + "_talkanim.tscn")
	talk_anim = talk_anim.instance()
	talk_anim.set_scale(Vector2(1.5,1.5))
	talk_anim.set_pos(Vector2(viewsize.x/2 + 40 - dialog.width/2, viewsize.y - dialog.posy + 20))
	get_node("ui_dialogue").add_child(talk_anim)

	reply_offset = 0

func create_labels(labels):
	kill_dialogue()
	for lbl in labels:
		if lbl == "panel":
			var node = Panel.new()
			node.set_name(lbl)
			get_node("ui_dialogue").add_child(node)
		if lbl == "dialogue":
			var node = dialog_panel.instance()
			node.set_name(lbl)
			get_node("ui_dialogue").add_child(node)
		#if I do "else:" code creates one reply too many, so this was the solution. Weird..
		if "reply" in lbl:
			var node = reply_button.instance()
			node.set_name(lbl)
			node.connect("reply_selected",self,"_pick_reply",[], CONNECT_ONESHOT)
			get_node("ui_dialogue").add_child(node)

func kill_dialogue():
	for x in get_node("ui_dialogue/").get_children():
		x.set_name("DELETED") #to make sure node doesn´t cause issues before being deleted
		x.queue_free()
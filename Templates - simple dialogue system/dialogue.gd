extends Node2D

var npc_dialogue = {"dialogue": "res://dialogue/empty.json", "branch": "a"}
var talk_data = {}
var debug

onready var dialog_panel = load("res://asset scenes/dialogue_window.tscn")
onready var reply_button = load("res://asset scenes/reply.tscn")

onready var viewsize = get_viewport().get_rect().size

var num_replies

func _ready():
	set_process(true)
	set_fixed_process(true)
	set_process_input(true)
	
	for object in get_node("npcs").get_children():
		object.connect("dialogue", self, "_talk_to")
		print("NPC connected.")
#
	start_dialogue(npc_dialogue)

func _talk_to(dialogue, branch):
	npc_dialogue = {"dialogue": dialogue, "branch": branch}
	start_dialogue(npc_dialogue)

func _pick_reply(n):
	if talk_data["dialogue"][npc_dialogue["branch"]]["responses"][n]["next"] != "exit":
		npc_dialogue["branch"] = talk_data["dialogue"][npc_dialogue["branch"]]["responses"][n]["next"]
		start_dialogue(npc_dialogue)
	else:
		kill_dialogue()
	
func start_dialogue(json):
	load_json(json, "dialogue")
	num_replies = talk_data["dialogue"][npc_dialogue["branch"]]["responses"].size()
	
	#setup dialog window
	dialogue_window()
	
	#set text and reply in dialogue panel
	get_node("ui_dialogue/Panel/dialogue").set_text(talk_data["dialogue"][npc_dialogue["branch"]]["text"])
	for n in range(0,num_replies):
		get_node("ui_dialogue/Panel/reply" + str(n+1)).set_text(talk_data["dialogue"][npc_dialogue["branch"]]["responses"][n]["reply"])
		
	#the below if-statement is necessary because of a bug that will make the NPC unresponsive to click, if start_dialogue() not called from _ready()
	#check github issue for more info, and please help if you can :)
	#https://github.com/CultOfApe/junkheap/issues/1
	if debug["dialogue"] == "res://dialogue/empty.json":
		kill_dialogue()
		
func load_json(json, type):
	var file = File.new();
	file.open(json["dialogue"], File.READ);
	talk_data.parse_json(file.get_as_text())
	file.close()
	debug = json

func dialogue_window():
		
	var reply_offset = 0
	var labels = ["dialogue"]
	
	#add one element "reply" per number of replies in talk_data
	for n in range(num_replies):
		labels.push_back("reply" + str(n+1))
		
	new_label(labels)
	
	var dialog = {"width": 800, "height": 100, "posx": 400, "posy": 370}
	
	get_node("ui_dialogue/Panel").set_size(Vector2(dialog.width, dialog.height + num_replies*30))
	get_node("ui_dialogue/Panel").set_pos(Vector2(viewsize.x/2 - dialog.posx, viewsize.y - dialog.posy))
	get_node("ui_dialogue/Panel").set_opacity(0.5)
	
	for n in range(num_replies):
		get_node("ui_dialogue/Panel/reply" + str(n+1)).set_size(Vector2(400, 50))
		get_node("ui_dialogue/Panel/reply" + str(n+1)).set_pos(Vector2(viewsize.x/2 - dialog.posx-100, viewsize.y - 550 + reply_offset))
		get_node("ui_dialogue/Panel/reply" + str(n+1)).num_reply = n
		reply_offset += 30

	reply_offset = 0

func new_label(labels):
	kill_dialogue()
	for lbl in labels:
		if lbl == "dialogue":
			var node = dialog_panel.instance()
			node.set_name(lbl)
			get_node("ui_dialogue/Panel").add_child(node)
		else:
			var node = reply_button.instance()
			node.set_name(lbl)
			node.connect("reply_selected",self,"_pick_reply",[], CONNECT_ONESHOT)
			get_node("ui_dialogue/Panel").add_child(node)

func kill_dialogue():
	for x in get_node("ui_dialogue/Panel").get_children():
		x.set_name("DELETED") #to make sure node doesn´t cause issues before being deleted
		x.queue_free()
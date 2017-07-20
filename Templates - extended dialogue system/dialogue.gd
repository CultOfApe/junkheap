extends Node2D

var npcDialogue = {}
var talkData = {}

onready var dialogPanel = load("res://asset scenes/dialogue_window.tscn")
onready var replyButton = load("res://asset scenes/reply.tscn")

onready var VIEWSIZE = get_viewport().get_rect().size
var dialog = {"width": 1000, "height": 60, "posx": 500, "posy": 370}

var npcName
var talkAnim

var numDialogueText = 0
var numReplies = 0
var pageIndex = 0
var replyContainer = []
var replyMouseover = "FALSE"
var replyCurrent = -1

var gameVars = {"milk": 0, "cookies": 0, "event": {"name": "start", "stage": 1}}

func _ready():
	set_process_input(true)
	
	for object in get_node("npcs").get_children():
		object.connect("dialogue", self, "_talk_to")
		
func event_handler():
	if gameVars.event.name == "Milk and cookies":
		if gameVars.event.stage == 1:
			pass

func _input(event):
	if replyMouseover == "FALSE":
		if event.is_action_pressed("ui_down") and replyCurrent != numReplies-1:
			replyCurrent += 1
			for reply in replyContainer:
				get_node(reply).add_color_override("font_color", Color(1,1,1))
			get_node(replyContainer[replyCurrent]).add_color_override("font_color", Color(1,0,1))
		if event.is_action_pressed("ui_up") and replyCurrent != 0:
			replyCurrent -= 1
			for reply in replyContainer:
				get_node(reply).add_color_override("font_color", Color(1,1,1))
			get_node(replyContainer[replyCurrent]).add_color_override("font_color", Color(1,0,1))
		if event.is_action_pressed("ui_exit"):
			print("ui_exit")
			if replyCurrent != -1:
				_pick_reply(replyCurrent)
			if pageIndex < numDialogueText-1:    
				pageIndex += 1
				start_dialogue(npcDialogue)
			if pageIndex < numDialogueText-1:    
				pageIndex += 1
				start_dialogue(npcDialogue)
			if pageIndex == numDialogueText-1 and numReplies == 0:
				kill_dialogue()
			
func _dialogue_clicked():
	if pageIndex < numDialogueText-1:    
		pageIndex += 1
		start_dialogue(npcDialogue)
	if pageIndex == numDialogueText-1 and numReplies == 0:
		kill_dialogue()

func _talk_to(dialogue, branch, name):
	npcDialogue = {"name": name,"dialogue": dialogue, "branch": branch}
	start_dialogue(npcDialogue)

func _pick_reply(n):
	replyCurrent =-1
	
	#if there is a variables array in json, update game variables
	if talkData["dialogue"][npcDialogue["branch"]]["replies"][n].has("variables"):
		for item in range(0, talkData["dialogue"][npcDialogue["branch"]]["replies"][n]["variables"].size()):
			var name = talkData["dialogue"][npcDialogue["branch"]]["replies"][n]["variables"][item]["name"]
			gameVars[name] = talkData["dialogue"][npcDialogue["branch"]]["replies"][n]["variables"][item]["value"]
			#if value is a float or an int, add to existing value
			if (typeof(talkData["dialogue"][npcDialogue["branch"]]["replies"][n]["variables"][item]["value"])) == 2:
				gameVars[name] += talkData["dialogue"][npcDialogue["branch"]]["replies"][n]["variables"][item]["value"]
			else:
				gameVars[name] = talkData["dialogue"][npcDialogue["branch"]]["replies"][n]["variables"][item]["value"]
		#print how many milk and cookies you have, mostly for debugging
		print("You have: " + str(gameVars.milk) + " milk")
		print("You have: " + str(gameVars.cookies) + " cookies")
		
	#if there is a progression array in json, update game progression variables
	if talkData["dialogue"][npcDialogue["branch"]]["replies"][n].has("progression"):
		for item in range(0, talkData["dialogue"][npcDialogue["branch"]]["replies"][n]["progression"].size()):
			var affected = talkData["dialogue"][npcDialogue["branch"]]["replies"][n]["progression"][item]["affected"]
			get_node("npcs/" + affected).identity.branch = talkData["dialogue"][npcDialogue["branch"]]["replies"][n]["progression"][item]["branch"]
	
	#if "exit" is "false" take value from "next" and start next dialogue
	if talkData["dialogue"][npcDialogue["branch"]]["replies"][n]["exit"] != "true":
		npcDialogue["branch"] = talkData["dialogue"][npcDialogue["branch"]]["replies"][n]["next"]
		pageIndex = 0
		start_dialogue(npcDialogue)
	
	#if "exit" is "true", kill dialogue
	else:
		pageIndex = 0
		npcDialogue["branch"] = talkData["dialogue"][npcDialogue["branch"]]["replies"][n]["next"]
		get_node("npcs/" + npcDialogue.name.to_lower()).identity = {"dialogue": "res://dialogue/"  + npcDialogue.name.to_lower() + ".json", "branch": npcDialogue.branch, "name": npcDialogue.name}
		kill_dialogue()

func _reply_mouseover(mouseover, reply):
	if mouseover == "TRUE":
		replyMouseover = "TRUE"
		replyCurrent = reply
	elif mouseover == "FALSE":
		replyMouseover = "FALSE"
		replyCurrent = -1

func start_dialogue(json):
	load_json(json, "dialogue")
	npcName = talkData["name"]
	if talkData["dialogue"][npcDialogue["branch"]].has("animation"):
		talkAnim = talkData["dialogue"][npcDialogue["branch"]]["animation"]

	numDialogueText = talkData["dialogue"][npcDialogue["branch"]]["text"].size()
	
	#if branch has responses, check how many. If no responses, numReplies is 0
	if talkData["dialogue"][npcDialogue["branch"]].has("replies"):
		numReplies = talkData["dialogue"][npcDialogue["branch"]]["replies"].size()
	else:
		#needed to add this otherwise paging didn´t work like it should
		replyMouseover = "FALSE"
		numReplies = 0
	
	#setup dialog window
	setup_dialogue_window()
	
	#set text and reply in dialogue panel
	get_node("ui_dialogue/dialogue/name").set_text(npcName)
	
	#preparing for dialogue paging, the 0 will be replaced by ´n´, ´n´ being order of item in text array
	get_node("ui_dialogue/dialogue").set_text(talkData["dialogue"][npcDialogue["branch"]]["text"][pageIndex])
	
	if pageIndex == numDialogueText-1 and numReplies > 0:
		for n in range(0,numReplies):
			replyContainer.push_back("ui_dialogue/reply" + str(n+1))
			get_node("ui_dialogue/reply" + str(n+1)).set_text(talkData["dialogue"][npcDialogue["branch"]]["replies"][n]["reply"])
		
func load_json(json, type):
	var file = File.new();
	file.open(json["dialogue"], File.READ);
	talkData.parse_json(file.get_as_text())
	file.close()
		
func setup_dialogue_window():
		
	var reply_offset = 0
	var labels = ["panel","dialogue"]
	
	#add one element "reply" per number of replies in talkData
	for n in range(numReplies):
		labels.push_back("reply" + str(n+1))
		
	create_labels(labels)
	
	get_node("ui_dialogue/panel").set_size(Vector2(dialog.width, dialog.height + numReplies*30))
	get_node("ui_dialogue/panel").set_pos(Vector2(VIEWSIZE.x/2 - dialog.width/2, VIEWSIZE.y - dialog.posy))
	get_node("ui_dialogue/panel").set_opacity(0.5)
	
	get_node("ui_dialogue/dialogue").set_size(Vector2(dialog.width -20, dialog.height + numReplies*30))
	get_node("ui_dialogue/dialogue").set_pos(Vector2(VIEWSIZE.x/2 + 100 - dialog.width/2, VIEWSIZE.y - dialog.posy + 20))
	
	if pageIndex == numDialogueText-1 and numReplies > 0:
		for n in range(numReplies):
			get_node("ui_dialogue/reply" + str(n+1)).set_size(Vector2(400, 50))
			get_node("ui_dialogue/reply" + str(n+1)).set_pos(Vector2(VIEWSIZE.x/2 +100 - dialog.width/2, VIEWSIZE.y - 300 + reply_offset))
			get_node("ui_dialogue/reply" + str(n+1)).num_reply = n
			reply_offset += 30
	
	talkAnim = load("res://asset scenes/" + npcName + "_talkanim.tscn")
	talkAnim = talkAnim.instance()
	talkAnim.set_scale(Vector2(1.5,1.5))
	talkAnim.set_pos(Vector2(VIEWSIZE.x/2 + 40 - dialog.width/2, VIEWSIZE.y - dialog.posy + 20))
	get_node("ui_dialogue").add_child(talkAnim)

	reply_offset = 0

func create_labels(labels):
	kill_dialogue()
	for lbl in labels:
		if lbl == "panel":
			var node = Panel.new()
			node.set_name(lbl)
			get_node("ui_dialogue").add_child(node)
		if lbl == "dialogue":
			var node = dialogPanel.instance()
			node.set_name(lbl)
			node.connect("dialogueClicked", self, "_dialogue_clicked")
			get_node("ui_dialogue").add_child(node)
		if pageIndex == numDialogueText-1:
			if "reply" in lbl:
				var node = replyButton.instance()
				node.set_name(lbl)
				node.connect("reply_selected",self,"_pick_reply",[], CONNECT_ONESHOT)
				node.connect("reply_mouseover",self,"_reply_mouseover")
				get_node("ui_dialogue").add_child(node)

func kill_dialogue():
	for x in get_node("ui_dialogue/").get_children():
		x.set_name("DELETED") #to make sure node doesn´t cause issues before being deleted
		#TODO: below set_pos() not necessary?
		x.set_pos(Vector2(-1000,-1000))
		x.queue_free()
	replyContainer = []

	
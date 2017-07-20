Simple Dialogue System (SDS)

Barebones dialogue system
- Displays dialogue text and replies in a box
- Dialogue box resizes dynamically to fit more replies
- Select replies with mouse
- Exit dialogue by clicking exit dialogue or ESC

Ape´s Dynamic Dialogue System (ADDS)
- named dialogues
- Dialogue text paging, allowing for longer dialogue
- Cycle through replies with arrow keys, select with SPACE or ENTER
- change game variables through dialogue decisions
- character progression flags

TODO:
- change "responses" to "replies" in json for consistency (Done in local repository)
- change names of variables and functions for consistency (Done in local repository)
	ex.
	vars should be camel case, ie num_replies should be numReplies
	functions should be snake case, ie my_function()
	constants should be upper case, ie viewsize should be VIEWSIZE
- if no replies, clicking on last dialogue page closes down dialogue (Done in local repository)
- add game progression flags, might affect not only characters (Done in local repository, no checks in dialogue.gd yet)
	#events can have several stages
	ex:
	"event": [{
	"name": "Milk and cookies"
	"stage": 1
	}]
- Dialogue animations should be settable per dialogue branch ()DONE in json (local repository). Remains to reflect that change in dialogue.gd
- add support in json for background image (Done in local repository, no checks in dialogue.gd yet)
- alot of cleanup to make code more readable at a glance. Right now understanding what´s going on in the code requires a bit of patience (I have added some guiding comments though):P

At first glance, having both character progression and event section might seem superfluous. Couldn´t you have them in the same section, as they´re both about game progression?
Yes you could, but I prefer to separate them, since progression should just be about character dialogue progression, whereas events could concievably
affect a large portion of the game, thus making dialogue trees difficult to overview. So, the idea is that every event has a separate json file, and 
a flag in the dialogue json to tell the engine to load the event json.

So, 

- character progression dictates which branch character follows in the current dialogue tree
- event progression dictates which dialogue tree character follows, but also things like which scenes and items are available

TO USE IN YOUR PROJECT (unfinished instructions):

instance dialogue.tscn into your project

add the following script to every Area that contains an NPC:

###

extends Area2D #obviously change this depending on if its Area or Area2D

signal dialogue(a,b,c)

var identity = {"dialogue": "res://dialogue/npc1.json", "branch": "a", "name": "NPC1"}

func _ready():
	pass

func _on_npc1_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			emit_signal("dialogue", identity.dialogue, identity.branch, identity.name)

###

If any questions, feel free to message me on Discord or Facebook (links on my profile)

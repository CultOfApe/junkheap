Extends Simple Dialogue System (SDS)
- Displays dialogue text and replies in a box
- Dialogue box resizes dynamically to fit more replies
- Select replies with mouse
- Exit dialogue by clicking exit dialogue or ESC

Ape´s Dynamic Dialogue System (ADDS)
- all of the above +
- named dialogues
- Dialogue text paging, allowing for longer dialogue
- Cycle through replies with arrow keys, select with SPACE or ENTER
- change game variables through dialogue decisions
- character progression flags

TODO:
- change "responses" to "replies" in json for consistency
- change names of variables and functions for consistency
	ex.
	vars should be camel case, ie num_replies should be numReplies
	functions should be snake case, ie my_function()
	constants should be upper case, ie viewsize should be VIEWSIZE
- if no replies, clicking on last dialogue page closes down dialogue (Done in local repository)
- add game progression flags, might affect not only characters
	#events can have several stages
	ex:
	"game progression": [{
	"event": "Milk and cookies"
	"stage": 1
	}]
- Dialogue animations should be settable per dialogue branch
	changes DONE in json (local repository). Remains to reflect that change in dialogue.gd

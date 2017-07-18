Extended Dialogue System (SDS)

extends Simple Dialogue System (SDS)

Barebones dialogue system
- Displays dialogue text and replies in a box
- Dialogue box resizes dynamically to fit more replies
- Select replies with mouse
- Exit dialogue by clicking exit dialogue or ESC

Extra features
- Character portrait animations
- Choose replies with keyboard (arrow keys, Enter to select)
- Character name label
- Change game variables through dialogue
- Dialogue text paging, allow for longer dialogue texts (click on dialogue or press Enter/Esc)

Notes to self:

# instead of having the game_vars dictionary and then assign to regular vars(below), why not just settle with the dictionary?
# so:
# game_vars.cookies = 3
# instead of:
# cookies = 3

var game_vars = {
  "milk": 0, 
  "cookies": 0}

func update_game_vars(vars):
	cookies = game_vars["cookies"]
	milk = game_vars["milk"]
	get_node("ui/cookies").set_text("cookies: " + str(cookies))
	get_node("ui/milk").set_text("milk: " + str(milk))
  
# becomes:  
  
var game_vars = {
  "milk": 0, 
  "cookies": 0}

func update_game_vars(vars):
	get_node("ui/cookies").set_text("cookies: " + str(game_vars.cookies))
	get_node("ui/milk").set_text("milk: " + str(game_vars.milk))
  
# and put game_vars in singleton? Would make using variables across scenes easier

# global.sd
extends Node

var vars = {
  "milk": 0, 
  "cookies": 0}
  
# main.sd
func update_game_vars(vars):
  get_node("ui/cookies").set_text("cookies: " + str(global.vars.cookies))
  get_node("ui/milk").set_text("milk: " + str(global.vars.milk))

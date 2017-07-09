extends Node

const TOKEN_SIZE = 32
const TOKEN_TYPES = {1: "circle", 2: "cross", 3: "square", 4: "triangle", 5: "gem", 6: "i"}
const BOARD_SIZE = Vector2(8,12)

var boardArray = {}
var boardOrigin = Vector2(370,100)

var matchArray = []

onready var token = load("res://token.tscn") 

func _ready():

	randomize()
	set_process_input(true)
	_init_game_board()
	
func _process_input(delta):

	if Input.is_action_pressed("ui_check"):
		_check_for_match()
	if Input-is_action_pressed("ui_kill_match"):
		_kill_tokens(matchArray)

func _init_game_board():
	
	var boardPos = boardOrigin

	# loop through rows
	for row in range(BOARD_SIZE.y):
		# loop through columns
		for col in range(BOARD_SIZE.x):		
			# assign random number %n to boardArray(x,y)
			boardArray[Vector2(col,row)] = randi()%4 +1
			var n = boardArray[Vector2(col,row)]
			var t = token.instance()
			t.type = n
			t.gridPos = boardPos
			t.set_pos(boardPos)
			t.set_text(str(t.type))
			get_node("tokens").add_child(t)  # DON´T ADD TO PANEL, CREATE NEW CONTAINER!
			boardPos.x += TOKEN_SIZE		
			
		boardPos = Vector2(370, boardPos.y + TOKEN_SIZE)

func _refill_game_board():
	pass

func _check_for_match():
	
	var match = {}
	var matchHorizontal = []
	var matchVertical = []
	var tokenType = null
	var tokenBoardPos = Vector2()
	var tokenCheckAgainst = null
	var tokenCheckAgainstPos = Vector2()
	var tokenCheckAdded = false
	var matchNum = 0

	#check for horizontal matches
	for row in range(BOARD_SIZE.y):
		
		for col in range(BOARD_SIZE.x):				
			tokenType = boardArray[Vector2(col, row)]	
			tokenBoardPos = Vector2(col, row)
				
			if tokenCheckAgainst:	
				if tokenCheckAgainst == tokenType:
					if tokenCheckAdded == false:
						matchNum += 1
						match["match"+str(matchNum)] = tokenCheckAgainstPos
						tokenCheckAdded = true
					match["match"+str(matchNum)] = tokenBoardPos
					
				else:		
					#if match.size() > 1:
					tokenCheckAgainst = null
					tokenCheckAdded == false
						#matchHorizontal.append([])
						#print(matchHorizontal)
						#for item in match:
						#	matchHorizontal.append(match[item])
						#matchNum += 1
								
			else:
				tokenCheckAgainst = tokenType
				tokenCheckAgainstPos = tokenBoardPos
	
		#after all columns in row checked, reset tokenCheckAgainst, so we don´t check between different rows
		tokenCheckAgainst = null
	#after horizontal match is done, reset match array
	print(match)
						
	
	#after vertical match is done, reset match array
	
	#for item in matchHorizontal:
		#print("subarray item")
		#boardArray[item] = "0"
	var q = get_node("tokens").get_child_count()
	#print(q)
	for subArray in matchHorizontal:
		for item in subArray:
			pass
			#var ch = boardArray[child]
			#ch.type = 0
			#print(boardArray[Vector2(4,5)]) #this gives correct result, so compare to Vector of matchHorizontal!
			#print(item)
	
func _on_checkForMatchLabel_button_down():
	print("Checking for match!")
	_check_for_match()
	

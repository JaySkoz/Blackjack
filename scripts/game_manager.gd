extends Node

@onready var deck: deck = get_parent().get_node("deck");
@onready var play_area_player : play_area = get_parent().get_node("play_area_player");
@onready var play_area_dealer : play_area = get_parent().get_node("play_area_dealer");
@onready var player_score : Label = play_area_player.get_node("score");
@onready var dealer_score : Label = play_area_dealer.get_node("score");

var HiddenCard : card = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	play_area_player.get_node("button_draw").connect("DrawPressed", DrawPressed);
	play_area_player.get_node("button_hit").connect("HitPressed", HitPressed);
	play_area_player.get_node("button_stay").connect("StayPressed", StayPressed);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass;

func StayPressed() -> void:
	#-- Stay pressed. Continue with dealer.
	await get_tree().create_timer(0.5).timeout;
	
	#-- todo - show second card.
	ShowHiddenCard();
	
	while int(dealer_score.text) < 17:
		await get_tree().create_timer(1.0).timeout;
		Draw(false,true);
		
		if int(dealer_score.text) > 21:
			await get_tree().create_timer(0.5).timeout;
			EndGame(true);
			return;
			
		if int(dealer_score.text) > int(player_score.text):
			await get_tree().create_timer(0.5).timeout;
			EndGame(false, "You Lose");
			return;
	
	await get_tree().create_timer(0.5).timeout;
	#-- Calculate score
	EndGame(true) if int(player_score.text) > int(dealer_score.text) else EndGame(false, "You Lose")

func HitPressed() -> void:
	await get_tree().create_timer(0.5).timeout;
	Draw(true, true);
	
	if int(player_score.text) > 21:
		EndGame(false, "Bust");

func DrawPressed() -> void:
	ButtonControllerBegin();
	
	#-- Clear the cards from the board.
	ClearCards();
	
	deck.Shuffle();
	await get_tree().create_timer(0.5).timeout
	Draw(true, true);
	await get_tree().create_timer(1.0).timeout
	Draw(false, true);
	await get_tree().create_timer(1.0).timeout
	Draw(true, true);
	await get_tree().create_timer(1.0).timeout
	Draw(false, false);
	
func Draw(isPlayer : bool, isFaceUp : bool):
	var curr_play_area : play_area = play_area_player if isPlayer else play_area_dealer;
	
	var face : String = deck.NewCard();
		
	#-- Load the card into the next available Marker2D
	var availableMarker : Marker2D = curr_play_area.GetNextAvailableMarker();
	
	#-- Put the card in the marker.
	var cardScene = null;
	
	cardScene = load("res://scenes/card/card.tscn").instantiate();
	
	var cardFace : Sprite2D = cardScene.get_node("face");
	
	if isFaceUp:
		cardFace.texture = load("res://assets/deck-of-cards-sorted/" + face + ".png");
	else:
		cardFace.texture = load("res://assets/deck-of-cards-sorted/Back2.png");
	
	cardScene.SetCardInfo(isFaceUp, face);
	
	availableMarker.add_child(cardScene);
	
	curr_play_area.UpdateScore();

func ButtonControllerBegin() -> void:
	#-- After initial deal, disable draw button, enable hit and stay buttons.
	var ButtonDraw : Button = play_area_player.get_node("button_draw");
	var ButtonHit : Button = play_area_player.get_node("button_hit");
	var ButtonStay : Button = play_area_player.get_node("button_stay");
	var LabelBust : Label = play_area_player.get_node("label_bust");
	var LabelWin : Label = play_area_player.get_node("label_win");
	
	ButtonDraw.visible = false;
	ButtonHit.visible = true;
	ButtonStay.visible = true;
	ButtonStay.disabled = false;
	player_score.visible = true;
	dealer_score.visible = true;
	LabelBust.visible = false;
	LabelWin.visible = false;
	
	player_score.text = "0";
	dealer_score.text = "0";

func ButtonControllerEnd() -> void:
	var ButtonDraw : Button = play_area_player.get_node("button_draw");
	var ButtonHit : Button = play_area_player.get_node("button_hit");
	var ButtonStay : Button = play_area_player.get_node("button_stay");
	var LabelBust : Label = play_area_player.get_node("label_bust");
	var LabelWin : Label = play_area_player.get_node("label_win");
	
	ButtonDraw.visible = true;
	ButtonHit.visible = false;
	ButtonStay.visible = true;
	ButtonStay.disabled = true;
	player_score.visible = true;
	dealer_score.visible = true;

func EndGame(isPlayerWin : bool, LoseLabel : String = ""):
	var LabelBust : Label = play_area_player.get_node("label_bust");
	var LabelWin : Label = play_area_player.get_node("label_win");
	
	ButtonControllerEnd();
	
	if isPlayerWin:
		LabelBust.visible = false;
		LabelWin.visible = true;
	else:
		LabelBust.text = LoseLabel
		LabelBust.visible = true;
		LabelWin.visible = false;
		
func ClearCards() -> void:
	for marker in play_area_player.get_tree().get_nodes_in_group("marker"):
		for child in marker.get_children():
			child.queue_free();
	
	for marker in play_area_dealer.get_tree().get_nodes_in_group("marker2"):
		for child in marker.get_children():
			child.queue_free();

func ShowHiddenCard() -> void:
	play_area_dealer.ShowHiddenCard();
	play_area_dealer.UpdateScore();

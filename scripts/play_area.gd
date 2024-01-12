class_name play_area

extends Node

@onready var MARKERS = [get_node("marker_card1"), get_node("marker_card2"), get_node("marker_card3"),
				get_node("marker_card4"), get_node("marker_card5")]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func CalculateScore() -> int:
	var calcscore : int = 0;
	
	for marker in MARKERS:
		var childcard : card = marker.get_child(0);
		
		if childcard != null:
			calcscore += childcard.VALUE;
	
	if calcscore > 21:
		for marker in MARKERS:
			var childcard : card = marker.get_child(0);
		
			if childcard != null:
				if childcard.isACE && childcard.VALUE == 11:
					childcard.VALUE = 1;
					return CalculateScore();
	
	return calcscore;

func UpdateScore() -> void:
	var LabelScore = get_node("score");
	LabelScore.text = str(CalculateScore());

func GetNextAvailableMarker() -> Marker2D:
	for marker in MARKERS:
		if marker.get_child_count() == 0:
			return marker;
	
	return null;

func ShowHiddenCard() -> void:
	for marker in MARKERS:
		var childcard : card = marker.get_child(0);
		if !childcard.isFACEUP:
			var cardFace : Sprite2D = childcard.get_node("face"); 
			cardFace.texture = load("res://assets/deck-of-cards-sorted/" + childcard.FACE + ".png");
			childcard.SetCardInfo(true, childcard.FACE)
			childcard.PlaySoundFlipped();
			return;

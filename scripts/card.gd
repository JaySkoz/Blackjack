class_name card
extends Node2D

var isFACEUP : bool = true;
var FACE : String = "";
var VALUE : int = 0;

func SetCardInfo(isFaceUp : bool, face : String) -> void:
	isFACEUP = isFaceUp;
	FACE = face;
	VALUE = GetCardValue();

func GetCardValue() -> int :
	if !isFACEUP : return 0;
	
	var cardPoints = FACE.split(".", false)[0];
	
	match (cardPoints):
		"A":
			return 11;
		"K", "Q", "J":
			return 10;
		_:
			return int(cardPoints);

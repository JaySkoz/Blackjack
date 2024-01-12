class_name card
extends Node2D

var isFACEUP : bool = true;
var isACE : bool = false;
var FACE : String = "";
var VALUE : int = 0;

@onready var PLACED_SOUND : AudioStreamPlayer2D = $AudioStream_placed;
@onready var FLIPPED_SOUND : AudioStreamPlayer2D = $AudioStream_flipped;

func SetCardInfo(isFaceUp : bool, face : String) -> void:
	isFACEUP = isFaceUp;
	FACE = face;
	VALUE = GetCardValue();

func GetCardValue() -> int :
	if !isFACEUP : return 0;
	
	var cardPoints = FACE.split(".", false)[0];
	
	match (cardPoints):
		"A":
			isACE = true;
			return 11;
		"K", "Q", "J":
			return 10;
		_:
			return int(cardPoints);

func PlaySoundPlaced() -> void:
	PLACED_SOUND.play();

func PlaySoundFlipped() -> void:
	FLIPPED_SOUND.play();

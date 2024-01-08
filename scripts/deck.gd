class_name deck
extends Node2D

var full_deck = [
	"2.2", "2.4", "2.5", "2.7", "3.2", "3.4", "3.5", "3.7", "4.2", "4.4", "4.5", "4.7", 
	"5.2", "5.4", "5.5", "5.7", "6.2", "6.4", "6.5", "6.7", "7.2", "7.4", "7.5", "7.7", 
	"8.2", "8.4", "8.5", "8.7", "9.2", "9.4", "9.5", "9.7", "10.2", "10.4", "10.5", "10.7", 
	"J.2", "J.4", "J.5", "J.7", "Q.2", "Q.4", "Q.5", "Q.7", "K.2", "K.4", "K.5", "K.7", 
	"A.2", "A.4", "A.5", "A.7",
]

var current_deck = []

func Shuffle():
	current_deck = full_deck.duplicate();

func NewCard() -> String:
	var card = current_deck[randi() % current_deck.size()];
	current_deck.erase(card);
	return card;

# Called when the node enters the scene tree for the first time.
func _ready():
	Shuffle();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

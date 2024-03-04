Class {
	#name : #FlashcardSessionTest,
	#superclass : #TestCase,
	#category : #'Flashcards-Tests'
}

{ #category : #tests }
FlashcardSessionTest >> testRetrievingEveryCard [
	| card1 card2 card3 populatedBox session |
	card1 := ($1 -> $1) asFlashcard.
	card2 := ($2 -> $2) asFlashcard.
	card3 := (($3 -> $3) asFlashcard) pass; yourself.
	
	populatedBox := FlashcardList withCards: { card1. card2. card3 }.
	session := FlashcardSession on: populatedBox with: { 1 }.
	
	session pickRandomCard; passCard.
	self deny: session isComplete.
	
	session pickRandomCard; failCard.
	self assert: session isComplete.
	
	
	self should: [session pickRandomCard] raise: Error
	
	
]

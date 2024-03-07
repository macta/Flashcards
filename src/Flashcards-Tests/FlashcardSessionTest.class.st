Class {
	#name : #FlashcardSessionTest,
	#superclass : #TestCase,
	#category : #'Flashcards-Tests'
}

{ #category : #tests }
FlashcardSessionTest >> testRetrievingEveryCard [
	| card1 card2 card3 cardList session selected1 selected2 |
	
	card1 := '1' asFlashcard.
	card2 := '2' asFlashcard.
	card3 := '3' asFlashcardInBox: 2.
	
	cardList := { card1. card2. card3 }.
	session := FlashcardSession on: cardList matching: [:c | c box = 1 ].
	
	self assert: session sessionCards equals: { card1. card2 } asOrderedCollection.
	self deny: session isComplete.
	
	selected1 := session pickRandomCard.
	self assert: session cardsLeft equals: 1.
	self deny: session isComplete.
	 
	self assert: (session verifyCard: selected1 withAnswer: selected1 answer).
	self assert: session passedCards equals: { selected1 } asOrderedCollection .
	self assert: session failedCards equals: { } asOrderedCollection.
	
	selected2 := session pickRandomCard.
	self assert: session remainingCards size equals: 0.
	self assert: session isComplete.
	 
	self deny: (session verifyCard: selected2 withAnswer: selected1 answer).
	self assert: session passedCards equals: { selected1 } asOrderedCollection.
	self assert: session failedCards equals: { selected2 } asOrderedCollection.
	
	self assert: (session pickRandomCardIfNone: [ true ]).
	
]

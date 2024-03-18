Class {
	#name : #FlashcardSessionTest,
	#superclass : #TestCase,
	#category : #'Flashcards-Tests'
}

{ #category : #tests }
FlashcardSessionTest >> testProgress [
	| card1 card2 cardList session |
	
	card1 := '1' asFlashcard.
	card2 := '2' asFlashcard.
	
	cardList := { card1. card2 }.
	session := FlashcardSession on: cardList.
	
	self assert: session progress equals: 0@2.
	
	session pickRandomCard.
	self assert: session progress equals: 1@2.
	
	session pickRandomCard.
	self assert: session progress equals: 2@2.
	 
	self assert: (session pickRandomCardIfNone: [ true ]).
	self assert: session progress equals: 2@2.
	
]

{ #category : #tests }
FlashcardSessionTest >> testRetrievingEveryCard [
	| card1 card2 cardList session selected1 selected2 |
	
	card1 := '1' asFlashcard.
	card2 := '2' asFlashcard.
	
	cardList := { card1. card2 }.
	session := FlashcardSession on: cardList.
	
	self assert: session sessionCards equals: { card1. card2 } asOrderedCollection.
	self deny: session isComplete.
	
	selected1 := session pickRandomCard.
	self assert: session cardsLeft equals: 1.
	self deny: session isComplete.
	 
	selected2 := session pickRandomCard.
	self assert: session remainingCards size equals: 0.
	self assert: session isComplete.
	 
	self assert: (session pickRandomCardIfNone: [ true ]).
	
]

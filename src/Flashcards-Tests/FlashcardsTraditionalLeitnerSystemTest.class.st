"
A FlashcardsTraditionalLeitnerSystemTest is a test class for testing the behavior of FlashcardsTraditionalLeitnerSystem
"
Class {
	#name : #FlashcardsTraditionalLeitnerSystemTest,
	#superclass : #TestCase,
	#category : #'Flashcards-Tests-Controllers'
}

{ #category : #tests }
FlashcardsTraditionalLeitnerSystemTest >> testAdvancingToNextSessionIncorporatesMultipleBoxes [

	| system card1 card2 selectedCard1 selectedCard2 allCards |
	system := FlashcardsTraditionalLeitnerSystem withBoxSequences: {{1}.{1. 2}}.

	card1 := ($1 -> $1) asFlashcard.
	card2 := ($2 -> $2) asFlashcard.
	allCards := { card1. card2 }.

	system addCards: allCards; nextSession.

	selectedCard1 := system pickRandomCard.
	system pass: selectedCard1.

	self deny: system hasCompletedSession.

	selectedCard2 := system pickRandomCard.
	system fail: selectedCard2.

	self assert: system hasCompletedSession.

	system nextSession.
	self deny: system hasCompletedSession.

	self
		assert: system remainingCards asSortedCollection
		equals: allCards asSortedCollection 
]

{ #category : #tests }
FlashcardsTraditionalLeitnerSystemTest >> testAdvancingToNextSessionRestrictsANewGroup [

	| system card1 card2 card3 cards |
	
	
	system := FlashcardsTraditionalLeitnerSystem withBoxSequences: {{1}. {1. 2}. {3}}.
	
	cards := { card1 := '1' asFlashcardInBox: 1. card2 := '2' asFlashcardInBox: 2. card3 := '3' asFlashcardInBox: 3.}.
	system addCards: cards.
	
	self assert: (system nextSession allCards) equals: {card1} asOrderedCollection .
	self assert: (system nextSession allCards) equals: {card1. card2} asOrderedCollection.
	self assert: (system nextSession allCards) equals: {card3} asOrderedCollection.
	self assert: (system nextSession allCards) equals: {card1} asOrderedCollection.
	self assert: (system nextSession allCards) equals: {card1. card2} asOrderedCollection.
	self assert: (system resetSession allCards) equals: {card1} asOrderedCollection.
	self assert: (system fullSession allCards) equals: cards asOrderedCollection.
]

{ #category : #tests }
FlashcardsTraditionalLeitnerSystemTest >> testMultipleIterations [

	| system card1 card2 card3 selectedCard1 selectedCard2 |
	
	system := FlashcardsTraditionalLeitnerSystem default.
	
	card1 := ($1 -> $1) asFlashcard.
	card2 := ($2 -> $2) asFlashcard.
	card3 := ($3 -> $3) asFlashcard.
	
	system addCards: { card1. card2. card3 }; nextSession.
	
	self assert: system numberPassed equals: 0.
	self assert: system numberFailed equals: 0.
	self assert: system remaining equals: 3.
	
	selectedCard1 := system pickRandomCard.
	
	self assert: system remaining equals: 2.
	
	system pass: selectedCard1.
	
	self assert: system remaining equals: 2.
	self assert: system numberPassed equals: 1.
	self assert: system numberFailed equals: 0.
	
	selectedCard2 := system pickRandomCard.
	
	system fail: selectedCard2.
	
	self assert: system remaining equals: 1.
	self assert: system numberPassed equals: 1.
	self assert: system numberFailed equals: 1.
]

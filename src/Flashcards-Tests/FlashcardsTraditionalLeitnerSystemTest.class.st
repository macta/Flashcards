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
	system := FlashcardsTraditionalLeitnerSystem default.

	card1 := ($1 -> $1) asFlashcard.
	card2 := ($2 -> $2) asFlashcard.
	allCards := { card1. card2 }.

	system addCards: allCards.

	selectedCard1 := system pickRandomCard.
	system pass: selectedCard1.

	self deny: system hasCompletedSession.

	selectedCard2 := system pickRandomCard.
	system fail: selectedCard2.

	self assert: system hasCompletedSession.

	system startSession.
	self deny: system hasCompletedSession.

	self
		assert: system remainingCards asSortedCollection
		equals: allCards asSortedCollection 
]

{ #category : #tests }
FlashcardsTraditionalLeitnerSystemTest >> testAdvancingToNextSessionRestrictsANewGroup [

	| system |
	
	system := FlashcardsTraditionalLeitnerSystem schedule: {{1}. {1. 2}. {2. 3}. {4}}.
	
	self assert: (system newSession; applicableBoxes) equals: {1}.
	self assert: (system nextSession; applicableBoxes) equals: {1. 2} .
	self assert: (system nextSession; applicableBoxes) equals: { 2. 3 }.
	self assert: (system newSession; applicableBoxes) equals: {1}.
	"self assert: (system fullSession; applicableBoxes) equals: {1. 2. 3. 4 }."
]

{ #category : #tests }
FlashcardsTraditionalLeitnerSystemTest >> testMultipleIterations [

	| system card1 card2 card3 selectedCard1 selectedCard2 |
	
	system := FlashcardsTraditionalLeitnerSystem default.
	
	card1 := ($1 -> $1) asFlashcard.
	card2 := ($2 -> $2) asFlashcard.
	card3 := ($3 -> $3) asFlashcard.
	
	system addCards: { card1. card2. card3 }; newSession.
	
	self assert: system passed equals: 0.
	self assert: system failed equals: 0.
	self assert: system remaining equals: 3.
	
	selectedCard1 := system pickRandomCard.
	
	self assert: system remaining equals: 2.
	
	system pass: selectedCard1.
	
	self assert: system remaining equals: 2.
	self assert: system passed equals: 1.
	
	selectedCard2 := system pickRandomCard.
	system fail: selectedCard2.
	
	self assert: system remaining equals: 1.
	self assert: system passed equals: 1.
	self assert: system failed equals: 1.
]

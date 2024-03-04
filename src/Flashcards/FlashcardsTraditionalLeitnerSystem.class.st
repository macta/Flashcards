Class {
	#name : #FlashcardsTraditionalLeitnerSystem,
	#superclass : #Object,
	#instVars : [
		'boxes',
		'random',
		'boxSequences',
		'selectedCard',
		'sessionCount',
		'flashcardSession'
	],
	#category : #'Flashcards-Controllers'
}

{ #category : #'as yet unclassified' }
FlashcardsTraditionalLeitnerSystem class >> default [

	^self withBoxSequences: { { 1 }. { 1. 2 }. { 1}. { 1.2 }. {1. 2. 3} }
]

{ #category : #'as yet unclassified' }
FlashcardsTraditionalLeitnerSystem class >> withBoxSequences: aCollectionOfSequences [
	^ self new
		boxSequences: aCollectionOfSequences;
		yourself
]

{ #category : #public }
FlashcardsTraditionalLeitnerSystem >> addCard: aCard [
	"The new card always goes into the first box"
	boxes first addCard: aCard.
]

{ #category : #adding }
FlashcardsTraditionalLeitnerSystem >> addCards: aCollection [ 
	self flashcardSession addCards: aCollection 
]

{ #category : #public }
FlashcardsTraditionalLeitnerSystem >> allCards [

	^self flashcardSession allCards 
]

{ #category : #public }
FlashcardsTraditionalLeitnerSystem >> applicableBoxes [
	
	^(self sessionFrequency withIndexCollect:  [ :f :i | (sessionCount \\ f) isZero ifTrue: [ i ] ifFalse: [ nil ]]) select: [ :each | each notNil ]
]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> boxSequences [

	^ boxSequences
]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> boxSequences: aCollection [ 
	boxSequences := aCollection
]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> boxes [
	^ boxes
]

{ #category : #asserting }
FlashcardsTraditionalLeitnerSystem >> fail: aFlashcard [ 
	self flashcardSession fail: aFlashcard 
]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> failed [
	
	^self flashcardSession failedCards size
]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> flashcardSession [

	^ flashcardSession ifNil: [ flashcardSession := FlashcardSession new ]
]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> flashcardSession: anObject [

	flashcardSession := anObject
]

{ #category : #public }
FlashcardsTraditionalLeitnerSystem >> hasCompletedSession [
	^self flashcardSession isComplete 
	
]

{ #category : #initialization }
FlashcardsTraditionalLeitnerSystem >> initialize [ 
	super initialize.
	random := Random new.
	sessionCount := 1.
	
]

{ #category : #private }
FlashcardsTraditionalLeitnerSystem >> moveSelectedCardBackwards [
	"This happens if the answer was wrong. The card is moved back to the first box"
	boxes first addCard: selectedCard.
]

{ #category : #private }
FlashcardsTraditionalLeitnerSystem >> moveSelectedCardForward [
	"This happens if the answer is correct. The card should progress to the next box. And if it was already taken from the last box, it is put back into the last box"
	| nextBoxNumber |
	
	nextBoxNumber := selectedBoxNumber = boxes size
		ifTrue: [ selectedBoxNumber ]
		ifFalse: [ selectedBoxNumber + 1].
		
	(boxes at: nextBoxNumber) addCard: selectedCard.
]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> numberOfBoxes [
	^ boxes size
]

{ #category : #'as yet unclassified' }
FlashcardsTraditionalLeitnerSystem >> pass: aFlashcard [ 
	self flashcardSession pass: aFlashcard 
]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> passed [
	^self flashcardSession passedCards size
]

{ #category : #public }
FlashcardsTraditionalLeitnerSystem >> pickRandomCard [

	^ selectedCard := self flashcardSession pickRandomCard
]

{ #category : #public }
FlashcardsTraditionalLeitnerSystem >> processAnswer: anAnswer [
	"Check the answer and move the card forward if the answer is correct or move it backwards if the answer is wrong"
	anAnswer = selectedCard answer
		ifTrue: [ self moveSelectedCardForward ]
		ifFalse: [ self moveSelectedCardBackwards ]
]

{ #category : #'as yet unclassified' }
FlashcardsTraditionalLeitnerSystem >> remaining [
	^self flashcardSession remainingCards size
]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> remainingCards [
	^self flashcardSession remainingCards .
]

{ #category : #public }
FlashcardsTraditionalLeitnerSystem >> removeCardNamed: aName ifAbsent: aBlock [
	^boxes removeCardNamed: aName ifAbsent: aBlock 
]

{ #category : #private }
FlashcardsTraditionalLeitnerSystem >> returnSelectedCard [
	"Put the selected card back in case you can't answer and want to pause"
	
	self selectedBox addCard: selectedCard.
]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> selectedCard [
	^ selectedCard
]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> selectedCard: anObject [

	selectedCard := anObject
]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> sessionCount [

	^ sessionCount
]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> sessionCount: anObject [

	sessionCount := anObject
]

{ #category : #public }
FlashcardsTraditionalLeitnerSystem >> sessionFrequency [ 

	^self boxSequences at: (self sessionCount  \\ self boxSequences size) + 1
]

{ #category : #'as yet unclassified' }
FlashcardsTraditionalLeitnerSystem >> startSession [

	self flashcardSession advanceIterationUsingBoxes: self sessionFrequency 
]

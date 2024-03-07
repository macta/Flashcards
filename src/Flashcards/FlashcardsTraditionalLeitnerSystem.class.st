Class {
	#name : #FlashcardsTraditionalLeitnerSystem,
	#superclass : #Object,
	#instVars : [
		'random',
		'selectedCard',
		'sessionCount',
		'cards',
		'flashcardSession',
		'sessionFrequencies'
	],
	#category : #'Flashcards-Controllers'
}

{ #category : #'as yet unclassified' }
FlashcardsTraditionalLeitnerSystem class >> default [

	^self withBoxSequences: { { 1 }. { 1. 2 }. { 1}. { 1.2 }. {1. 2. 3} }
]

{ #category : #schedulling }
FlashcardsTraditionalLeitnerSystem class >> schedule: aCollectionOfSequences [ 
	^self new
		sessionFrequencies: aCollectionOfSequences;
		yourself
]

{ #category : #'as yet unclassified' }
FlashcardsTraditionalLeitnerSystem class >> withBoxSequences: aCollectionOfSequences [
	^ self new
		sessionFrequencies: aCollectionOfSequences;
		yourself
]

{ #category : #public }
FlashcardsTraditionalLeitnerSystem >> addCard: aCard [

	self cards add: aCard.
]

{ #category : #adding }
FlashcardsTraditionalLeitnerSystem >> addCards: aCollection [ 
	aCollection do: [ :c | self addCard: c ]
]

{ #category : #public }
FlashcardsTraditionalLeitnerSystem >> allCards [

	^self cards
]

{ #category : #public }
FlashcardsTraditionalLeitnerSystem >> applicableBoxes [
	
	^self sessionFrequency 
]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> cards [

	^ cards
]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> cards: anObject [

	cards := anObject
]

{ #category : #'instance creation' }
FlashcardsTraditionalLeitnerSystem >> createSession [
	^self createSession: self applicableBoxes
]

{ #category : #'instance creation' }
FlashcardsTraditionalLeitnerSystem >> createSession: frequencies [
	
	^FlashcardSession on: self cards matching: [ :c | frequencies includes: c box ]
]

{ #category : #asserting }
FlashcardsTraditionalLeitnerSystem >> fail: aFlashcard [ 
	self flashcardSession failCard: aFlashcard 
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

	^flashcardSession := anObject
]

{ #category : #'as yet unclassified' }
FlashcardsTraditionalLeitnerSystem >> fullSession [
	| f |
	f := self sessionFrequencies flatCollectAsSet: [:c | c].
	^self createSession: f asSortedCollection 
]

{ #category : #public }
FlashcardsTraditionalLeitnerSystem >> hasCompletedSession [
	^self flashcardSession isComplete 
	
]

{ #category : #initialization }
FlashcardsTraditionalLeitnerSystem >> initialize [ 
	super initialize.
	random := Random new.
	cards := OrderedCollection new.
	sessionCount := 1.
	
]

{ #category : #'instance creation' }
FlashcardsTraditionalLeitnerSystem >> newSession [
	
	self sessionCount: 1.
	^self flashcardSession: self createSession.
	
]

{ #category : #public }
FlashcardsTraditionalLeitnerSystem >> nextCardAfter: aFlashcard given: aBlock [
	"Check the answer and move the card forward if the answer is correct or move it backwards if the answer is wrong"
	
	aBlock value
		ifTrue: [ self flashcardSession pass: aFlashcard ]
		ifFalse: [ self flashcardSession fail: aFlashcard ]
]

{ #category : #public }
FlashcardsTraditionalLeitnerSystem >> nextCardAfter: aFlashcard given: answerBlock otherwise: finishedBock [
	"Check the answer and move the card forward if the answer is correct or move it backwards if the answer is wrong"

	answerBlock value
		ifTrue: [ self flashcardSession pass: aFlashcard ]
		ifFalse: [ self flashcardSession fail: aFlashcard ].

	^ self flashcardSession isComplete
		  ifTrue: finishedBock
		  ifFalse: [ self flashcardSession pickRandomCard ]
]

{ #category : #'as yet unclassified' }
FlashcardsTraditionalLeitnerSystem >> nextSession [
	self sessionCount: self sessionCount +1.
	^self createSession 
]

{ #category : #'as yet unclassified' }
FlashcardsTraditionalLeitnerSystem >> pass: aFlashcard [ 
	self flashcardSession passCard: aFlashcard 
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
FlashcardsTraditionalLeitnerSystem >> pickRandomCardOtherwise: aBlock [

	self flashcardSession isComplete ifTrue: [ ^aBlock value ].
	
	^ selectedCard := self flashcardSession pickRandomCard
]

{ #category : #public }
FlashcardsTraditionalLeitnerSystem >> processAnswer: anAnswer [
	"Check the answer and move the card forward if the answer is correct or move it backwards if the answer is wrong"
	anAnswer = selectedCard answer
		ifTrue: [ self moveSelectedCardForward ]
		ifFalse: [ self moveSelectedCardBackwards ]
]

{ #category : #public }
FlashcardsTraditionalLeitnerSystem >> processAnswer: anAnswer for: aFlashcard [
	"Check the answer and move the card forward if the answer is correct or move it backwards if the answer is wrong"
	
	self nextCardAfter: aFlashcard  given: [ aFlashcard answer = anAnswer ]
]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> progress [
	^self flashcardSession progress
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
	self flashcardSession isComplete ifFalse: [ self error: 'Cant remove with active session' ].
	self cards removeAllSuchThat: [ :c | c question = aName ]. 
	
]

{ #category : #initialization }
FlashcardsTraditionalLeitnerSystem >> reset [
	
	sessionCount := 1.
	self flashcardSession reset.
	
]

{ #category : #initialization }
FlashcardsTraditionalLeitnerSystem >> resetSession [
	self flashcardSession reset.
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

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> sessionFrequencies [

	^ sessionFrequencies
]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> sessionFrequencies: aCollection [ 
	sessionFrequencies := aCollection
]

{ #category : #public }
FlashcardsTraditionalLeitnerSystem >> sessionFrequency [ 

	^self sessionFrequencies at: (self sessionCount  \\ self sessionFrequencies size) + 0
]

{ #category : #'as yet unclassified' }
FlashcardsTraditionalLeitnerSystem >> startSession [

	self flashcardSession advanceIterationUsingBoxes: self sessionFrequency 
]

Class {
	#name : #FlashcardsTraditionalLeitnerSystem,
	#superclass : #Object,
	#instVars : [
		'random',
		'selectedCard',
		'sessionCount',
		'cards',
		'passedCards',
		'failedCards',
		'flashcardSession',
		'sessionBoxFilters'
	],
	#category : #'Flashcards-Controllers'
}

{ #category : #'as yet unclassified' }
FlashcardsTraditionalLeitnerSystem class >> default [
  "Instantiate the receiver with a sequence of box visits that alternates with known cards being spaced between trickier ones. see: https://examstudyexpert.com/leitner-system/"

	^self withBoxSequences: { { 1. 2}. { 1 }. { 1. 2}. { 1 }. {1. 2. 3}. {1} }
]

{ #category : #'as yet unclassified' }
FlashcardsTraditionalLeitnerSystem class >> withBoxSequences: aCollectionOfSequences [
	^ self new
		sessionBoxFilters: aCollectionOfSequences;
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
FlashcardsTraditionalLeitnerSystem >> boxCounts [

	^self cards groupedBy: [ :c | c box ]
]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> cards [

	^ cards
]

{ #category : #'instance creation' }
FlashcardsTraditionalLeitnerSystem >> createSession [

	^ self createSessionUsing: self sessionBoxFilter
]

{ #category : #'instance creation' }
FlashcardsTraditionalLeitnerSystem >> createSessionUsing: frequencies [
	passedCards := OrderedCollection new.
	failedCards := OrderedCollection new.
	^FlashcardSession on: (self cards select: [ :c | frequencies includes: c box ])
]

{ #category : #public }
FlashcardsTraditionalLeitnerSystem >> fail: aFlashcard [

	self process: [false] for: aFlashcard 
]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> failedCards [

	^ failedCards
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
	f := self sessionBoxFilters flatCollectAsSet: [:c | c].
	^self createSessionUsing: f asSortedCollection 
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
	
	sessionCount := 0.
	
]

{ #category : #'as yet unclassified' }
FlashcardsTraditionalLeitnerSystem >> nextSession [

	self sessionCount: self sessionCount + 1.
	^self flashcardSession: self createSession.
	
]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> numberFailed [
	
	^self failedCards size
]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> numberPassed [
	^self passedCards size
]

{ #category : #public }
FlashcardsTraditionalLeitnerSystem >> pass: aFlashcard [

	self process: [true] for: aFlashcard 
]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> passedCards [

	^ passedCards
]

{ #category : #public }
FlashcardsTraditionalLeitnerSystem >> pickRandomCard [

	^ self pickRandomCardOtherwise: [ NullFlashcard singleton ]
]

{ #category : #public }
FlashcardsTraditionalLeitnerSystem >> pickRandomCardOtherwise: aBlock [

	self flashcardSession isComplete ifTrue: [ 
		selectedCard := NullFlashcard singleton.
		^aBlock value ].
	
	^ selectedCard := self flashcardSession pickRandomCard
]

{ #category : #public }
FlashcardsTraditionalLeitnerSystem >> process: answerBlock for: aFlashcard [
	"Check the answer and move the card forward if the answer is correct or move it backwards if the answer is wrong"

	answerBlock value
		ifTrue: [
			(aFlashcard hasReachedBoxLimit: self repetitionCount) ifFalse: [ aFlashcard pass ].
			self passedCards add: aFlashcard ]
		ifFalse: [ self failedCards add: aFlashcard fail ]
]

{ #category : #public }
FlashcardsTraditionalLeitnerSystem >> processAnswer: anAnswer [
	"Check the answer and move the card forward if the answer is correct or move it backwards if the answer is wrong"

	self processAnswer: anAnswer for: self selectedCard 
]

{ #category : #public }
FlashcardsTraditionalLeitnerSystem >> processAnswer: anAnswer for: aFlashcard [
	"Check the answer and move the card forward if the answer is correct or move it backwards if the answer is wrong"
	
	self process: [ aFlashcard answer = anAnswer ] for: aFlashcard
]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> progress [
	^self flashcardSession progress
]

{ #category : #'as yet unclassified' }
FlashcardsTraditionalLeitnerSystem >> remaining [
	^self remainingCards size
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

{ #category : #public }
FlashcardsTraditionalLeitnerSystem >> repetitionCount [
	"Answer the number of test repetitions defined before it cycles around"
	
	^self sessionBoxFilters size
]

{ #category : #initialization }
FlashcardsTraditionalLeitnerSystem >> reset [
	
	sessionCount := 1.
	self flashcardSession reset.
	
]

{ #category : #initialization }
FlashcardsTraditionalLeitnerSystem >> resetSession [
	self sessionCount: 0.
	^self nextSession
]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> selectedCard [
	^ selectedCard ifNil: [ selectedCard := NullFlashcard singleton ]
]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> selectedCard: anObject [

	selectedCard := anObject
]

{ #category : #public }
FlashcardsTraditionalLeitnerSystem >> sessionBoxFilter [ 

	^self sessionBoxFilters at: (self sessionCount - 1 \\ self sessionBoxFilters size) + 1
	

]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> sessionBoxFilters [

	^ sessionBoxFilters
]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> sessionBoxFilters: aCollectionOfBoxGroups [ 
	sessionBoxFilters := aCollectionOfBoxGroups
]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> sessionCount [

	^ sessionCount
]

{ #category : #accessing }
FlashcardsTraditionalLeitnerSystem >> sessionCount: anObject [

	sessionCount := anObject
]

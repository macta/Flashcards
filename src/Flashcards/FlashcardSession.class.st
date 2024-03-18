Class {
	#name : #FlashcardSession,
	#superclass : #Object,
	#instVars : [
		'passedCards',
		'failedCards',
		'currentCard',
		'sessionCards',
		'initialCards'
	],
	#category : #'Flashcards-Models'
}

{ #category : #'instance creation' }
FlashcardSession class >> new [
	^self on: OrderedCollection new
]

{ #category : #'instance creation' }
FlashcardSession class >> on: aCollection [

	^ self on: aCollection matching: [ :c | c box = 1 ]
]

{ #category : #'as yet unclassified' }
FlashcardSession class >> on: aCollection matching: aBlock [ 
	^self basicNew 
		initializeOn: aCollection matching: aBlock ;
		yourself
]

{ #category : #'instance creation' }
FlashcardSession class >> onEverything: aCollection [

	^ self on: aCollection matching: [ :c | true ]
]

{ #category : #accessing }
FlashcardSession >> allCards [

	^initialCards 
]

{ #category : #accessing }
FlashcardSession >> boxes [ 

	^self allCards inject: Set new into: [ :r :c | r add: c box ]
]

{ #category : #'as yet unclassified' }
FlashcardSession >> cardsLeft [
	^self sessionCards size
]

{ #category : #accessing }
FlashcardSession >> clearCurrentCard [

	self currentCard: NullFlashcard singleton
]

{ #category : #accessing }
FlashcardSession >> completedCards [

	^self passedCards, self failedCards 
]

{ #category : #accessing }
FlashcardSession >> currentCard [

	^ currentCard
]

{ #category : #accessing }
FlashcardSession >> currentCard: anObject [

	^currentCard := anObject
]

{ #category : #accessing }
FlashcardSession >> failCard: aFlashcard [

	self failedCards add: aFlashcard fail.
	self clearCurrentCard
]

{ #category : #accessing }
FlashcardSession >> failCurrentCard [
	self failedCards add: self currentCard fail.
	self clearCurrentCard
]

{ #category : #accessing }
FlashcardSession >> failedCards [

	^ failedCards ifNil: [ failedCards := OrderedCollection new ]
]

{ #category : #accessing }
FlashcardSession >> hasCurrentCard [ 

	^self currentCard notNil
]

{ #category : #initialization }
FlashcardSession >> initializeOn: aCollection matching: aFullBlockClosure [ 
	initialCards := (aCollection select: aFullBlockClosure) asOrderedCollection.
	sessionCards := initialCards copy.
	self clearCurrentCard.
	
]

{ #category : #testing }
FlashcardSession >> isComplete [
	^self sessionCards isEmpty
]

{ #category : #accessing }
FlashcardSession >> passCard: aFlashcard [

	self passedCards add: aFlashcard pass.
	self clearCurrentCard
]

{ #category : #accessing }
FlashcardSession >> passCurrentCard [

	self passedCards add: self currentCard pass.
	self clearCurrentCard
]

{ #category : #accessing }
FlashcardSession >> passedCards [

	^ passedCards ifNil: [ passedCards := OrderedCollection new ]
]

{ #category : #'as yet unclassified' }
FlashcardSession >> pickRandomCard [
		| selectedCard |
	
	self isComplete ifTrue: [
		Error signal: 'No cards left' ].
	
	selectedCard := self sessionCards atRandom.
	self sessionCards remove: selectedCard.
	^ self currentCard: selectedCard  
	
]

{ #category : #'as yet unclassified' }
FlashcardSession >> pickRandomCardIfNone: aBlock [

	^ self isComplete
		  ifTrue: [
			  self clearCurrentCard.
			  aBlock value ]
		  ifFalse: [ self pickRandomCard ]
]

{ #category : #accessing }
FlashcardSession >> progress [
	^(self completedCards size + self currentCard progressValue)@(self allCards size) 
]

{ #category : #accessing }
FlashcardSession >> remainingCards [

	^  self sessionCards 
]

{ #category : #'as yet unclassified' }
FlashcardSession >> reset [
	sessionCards := initialCards copy.
	
	failedCards := nil.
	passedCards:= nil.
	
	self clearCurrentCard.
	
]

{ #category : #accessing }
FlashcardSession >> sessionCards [

	^ sessionCards
]

{ #category : #'as yet unclassified' }
FlashcardSession >> verifyCard: aFlashcard withAnswer: aString [

	^ (aFlashcard matches: aString)
		  ifTrue: [
			  self passCard: aFlashcard.
			  true ]
		  ifFalse: [
			  self failCard: aFlashcard.
			  false ]
]

Class {
	#name : #FlashcardSession,
	#superclass : #Object,
	#instVars : [
		'sessionCards',
		'initialCards',
		'selectedCards'
	],
	#category : #'Flashcards-Models'
}

{ #category : #'instance creation' }
FlashcardSession class >> new [
	^self on: OrderedCollection new
]

{ #category : #'as yet unclassified' }
FlashcardSession class >> on: aCollection [ 
	^self basicNew 
		initializeOn: aCollection;
		yourself
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
FlashcardSession >> currentCard [

	^ self selectedCards last
]

{ #category : #initialization }
FlashcardSession >> initializeOn: aCollection [
	initialCards := aCollection asOrderedCollection.
	self reset
	
	
]

{ #category : #testing }
FlashcardSession >> isComplete [
	^self sessionCards isEmpty
]

{ #category : #'as yet unclassified' }
FlashcardSession >> pickRandomCard [

	| selectedCard |
	
	self isComplete ifTrue: [ Error signal: 'No cards left' ].

	selectedCards add: (selectedCard := self sessionCards atRandom).
	self sessionCards remove: selectedCard.
	^selectedCard
]

{ #category : #'as yet unclassified' }
FlashcardSession >> pickRandomCardIfNone: aBlock [

	^ self isComplete
		  ifTrue: aBlock value
		  ifFalse: [ self pickRandomCard ]
]

{ #category : #accessing }
FlashcardSession >> progress [
	^(self selectedCards size)@(self allCards size) 
]

{ #category : #accessing }
FlashcardSession >> remainingCards [

	^ self sessionCards 
]

{ #category : #'as yet unclassified' }
FlashcardSession >> reset [
	sessionCards := initialCards copy.
	selectedCards := OrderedCollection new.
	
]

{ #category : #accessing }
FlashcardSession >> selectedCards [

	^ selectedCards
]

{ #category : #accessing }
FlashcardSession >> sessionCards [

	^ sessionCards
]

Class {
	#name : #FlashcardList,
	#superclass : #Object,
	#instVars : [
		'cards'
	],
	#category : #'Flashcards-Models'
}

{ #category : #'as yet unclassified' }
FlashcardList class >> withCards: aCollection [

	^ self new
		  addCards: aCollection;
		  yourself
]

{ #category : #adding }
FlashcardList >> addCard: aCard [
	cards add: aCard
]

{ #category : #adding }
FlashcardList >> addCards: aCardCollection [
	
	aCardCollection do: [ :c | 	self addCard: c ]
]

{ #category : #'as yet unclassified' }
FlashcardList >> allCardsInBox: aBoxNumber [
	^self allCardsSelectingFrom: [ :card | card box = aBoxNumber ]
]

{ #category : #'as yet unclassified' }
FlashcardList >> allCardsSelectingFrom: aBlock [
	"Selects a random card, removes it from the box, and returns the selected card. This way the card is taken out of the box"
	
	^self cards select: aBlock
]

{ #category : #'as yet unclassified' }
FlashcardList >> availableBoxes [
	"Answer the Collection of box group id's that are available to take a card from. e.g.  {1. 3. 4"
	
	^(self cards groupedBy: [ :c | c box ]) keys asSortedCollection 
]

{ #category : #accessing }
FlashcardList >> cards [
	^ cards
]

{ #category : #initialization }
FlashcardList >> initialize [ 	
	super initialize.
	cards := OrderedCollection new.
]

{ #category : #testing }
FlashcardList >> isEmpty [ 
	^ cards isEmpty 
]

{ #category : #'as yet unclassified' }
FlashcardList >> numberOfBoxes [
	^self availableBoxes size
]

{ #category : #accessing }
FlashcardList >> numberOfCards [
	^ cards size
]

{ #category : #'as yet unclassified' }
FlashcardList >> pickRandomCard [
	"Selects a random card, removes it from the box, and returns the selected card. This way the card is taken out of the box"
	| selectedCard |
	
	self isEmpty ifTrue: [
		Error signal: 'All boxes empty' ].
	
	selectedCard := cards atRandom.
	^ selectedCard 
	
]

{ #category : #'as yet unclassified' }
FlashcardList >> pickRandomCardFromBox: aBox [
	"Selects a random card, removes it from the box, and returns the selected card. This way the card is taken out of the box"
	
	| selectedCard |
	^selectedCard := self pickRandomCardSelectingFrom: [ :c | c box = aBox ].
	
	
]

{ #category : #'as yet unclassified' }
FlashcardList >> pickRandomCardSelectingFrom: aBlock [
	"Selects a random card, removes it from the box, and returns the selected card. This way the card is taken out of the box"
	| selectedCard applicableCards |
	
	applicableCards := self allCardsSelectingFrom: aBlock.
	applicableCards ifEmpty: [
		Error signal: ('Could not select any cards using: ', aBlock printString) ].
	
	selectedCard := applicableCards atRandom.
	^selectedCard.
	
]

{ #category : #'as yet unclassified' }
FlashcardList >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPutAll: '(cards: ';
		print: self numberOfCards;
		nextPut: $)
]

{ #category : #adding }
FlashcardList >> removeAt: anIndex [
	cards removeAt: anIndex
]

{ #category : #adding }
FlashcardList >> removeCard: aCard [
	^cards remove: aCard
]

{ #category : #adding }
FlashcardList >> removeCard: aCard ifAbsent: aBlock [
	^cards remove: aCard ifAbsent: aBlock
]

{ #category : #accessing }
FlashcardList >> removeCardNamed: aName ifAbsent: aBlock [

	cards doWithIndex: [ :c :i |
		c question = aName ifTrue: [ ^ cards removeAt: i ] ].
	
	^ aBlock value
]

Class {
	#name : #FlashcardSession,
	#superclass : #Object,
	#instVars : [
		'passedCards',
		'failedCards',
		'currentCard',
		'iteration',
		'applicableBoxes',
		'flashcardList'
	],
	#category : #'Flashcards-Models'
}

{ #category : #'instance creation' }
FlashcardSession class >> new [
	^self on: FlashcardList new
]

{ #category : #'instance creation' }
FlashcardSession class >> on: aFlashcardBox [

	^ self on: aFlashcardBox with: { 1 }
]

{ #category : #'instance creation' }
FlashcardSession class >> on: aFlashcardBox with: applicableBoxes [

	^ self basicNew
		  flashcardList: aFlashcardBox;
		  applicableBoxes: applicableBoxes;
		  yourself
]

{ #category : #adding }
FlashcardSession >> addCards: aCollection [ 
	self flashcardList addCards: aCollection 
]

{ #category : #'as yet unclassified' }
FlashcardSession >> advanceIterationUsingBoxes: sequences [
	self flashcardList addCards: self completedCards.
	self applicableBoxes: sequences.
	self failedCards: nil.
	self passedCards: nil.
	^self iteration: self iteration + 1
]

{ #category : #'as yet unclassified' }
FlashcardSession >> allCardsInBoxes: aCollection [

	^ aCollection inject: OrderedCollection new into: [ :result :box |
		  result
			  addAll: (self flashcardList allCardsInBox: box);
			  yourself ]
]

{ #category : #public }
FlashcardSession >> applicableBoxes [
	^applicableBoxes 
]

{ #category : #accessing }
FlashcardSession >> applicableBoxes: anObject [

	applicableBoxes := anObject
]

{ #category : #accessing }
FlashcardSession >> applicableCards [

	^self flashcardList allCardsSelectingFrom: [ :c | self applicableBoxes includes: c box ]
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

{ #category : #asserting }
FlashcardSession >> fail: aFlashcard [ 
	self failCard 
]

{ #category : #accessing }
FlashcardSession >> failCard [

	
	^ self failedCards add: (self flashcardList removeCard: self currentCard fail).
]

{ #category : #accessing }
FlashcardSession >> failedCards [

	^ failedCards ifNil: [ failedCards := OrderedCollection new ]
]

{ #category : #accessing }
FlashcardSession >> failedCards: anObject [

	failedCards := anObject
]

{ #category : #accessing }
FlashcardSession >> flashcardList [

	^ flashcardList 
]

{ #category : #accessing }
FlashcardSession >> flashcardList: anObject [

	flashcardList := anObject
]

{ #category : #accessing }
FlashcardSession >> hasCurrentCard [ 

	^self currentCard notNil
]

{ #category : #testing }
FlashcardSession >> isComplete [
	^self remainingCards isEmpty
]

{ #category : #accessing }
FlashcardSession >> iteration [

	^ iteration ifNil: [ iteration := 1 ]
]

{ #category : #accessing }
FlashcardSession >> iteration: anObject [

	iteration := anObject
]

{ #category : #'as yet unclassified' }
FlashcardSession >> pass: aFlashcard [ 
	self passCard 
]

{ #category : #accessing }
FlashcardSession >> passCard [

	^ self passedCards add: (self flashcardList removeCard: currentCard pass)
]

{ #category : #accessing }
FlashcardSession >> passedCards [

	^ passedCards ifNil: [ passedCards := OrderedCollection new ]
]

{ #category : #accessing }
FlashcardSession >> passedCards: anObject [

	passedCards := anObject
]

{ #category : #'as yet unclassified' }
FlashcardSession >> pickRandomCard [
	| card |
	card := self flashcardList pickRandomCardSelectingFrom: [ :c | self applicableBoxes includes: c box ].
	^self currentCard: card
]

{ #category : #accessing }
FlashcardSession >> remainingCards [

	^  self applicableCards
]

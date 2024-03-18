Class {
	#name : #FlashcardsProbabilityLeitnerSystem,
	#superclass : #Object,
	#instVars : [
		'boxes',
		'random',
		'boxCumulativeProbabilities',
		'selectedBoxNumber',
		'selectedCard',
		'cards'
	],
	#category : #'Flashcards-Controllers'
}

{ #category : #'as yet unclassified' }
FlashcardsProbabilityLeitnerSystem class >> defaultProbabilities [
	^ #(0.5 0.25 0.125 0.05)
]

{ #category : #'as yet unclassified' }
FlashcardsProbabilityLeitnerSystem class >> withProbabilities: aCollectionOfProbabilities [
	^ self new
		initializeDefaultBoxes: aCollectionOfProbabilities;
		yourself
]

{ #category : #public }
FlashcardsProbabilityLeitnerSystem >> addCard: aCard [

	self cards add: aCard.
]

{ #category : #accessing }
FlashcardsProbabilityLeitnerSystem >> addCards: aCollection [ 
	aCollection do: [ :c | self addCard: c ]
]

{ #category : #public }
FlashcardsProbabilityLeitnerSystem >> allCards [

	^self cards
]

{ #category : #accessing }
FlashcardsProbabilityLeitnerSystem >> boxes [
	^ boxes
]

{ #category : #accessing }
FlashcardsProbabilityLeitnerSystem >> cards [

	^ cards
]

{ #category : #accessing }
FlashcardsProbabilityLeitnerSystem >> cards: anObject [

	cards := anObject
]

{ #category : #public }
FlashcardsProbabilityLeitnerSystem >> fail: aFlashcard [ 
	selectedCard fail.
	  
]

{ #category : #initialization }
FlashcardsProbabilityLeitnerSystem >> initialize [ 
	super initialize.
	random := Random new.
	cards := OrderedCollection new.
	self initializeDefaultBoxes.
]

{ #category : #initialization }
FlashcardsProbabilityLeitnerSystem >> initializeDefaultBoxes [
	self initializeDefaultBoxes: self class defaultProbabilities.
]

{ #category : #initialization }
FlashcardsProbabilityLeitnerSystem >> initializeDefaultBoxes: aCollectionOfProbabilities [
	| sum |
	
	boxes := OrderedCollection new.
	"aCollectionOfProbabilities size timesRepeat: [ boxes add: FlashcardList new ]".
	
	sum := 0.
	boxCumulativeProbabilities := OrderedCollection new.
	
	aCollectionOfProbabilities withIndexDo: [ :probability :i |
		sum := sum + probability.
		boxCumulativeProbabilities add: sum ].
]

{ #category : #private }
FlashcardsProbabilityLeitnerSystem >> moveSelectedCardBackwards [
	"This happens if the answer was wrong. The card is moved back to the first box"
	selectedCard fail.
]

{ #category : #private }
FlashcardsProbabilityLeitnerSystem >> moveSelectedCardForward [
	"This happens if the answer is correct. The card should progress to the next box. And if it was already taken from the last box, it is put back into the last box"
	selectedCard box < boxCumulativeProbabilities size ifTrue: [ selectedCard pass ].
]

{ #category : #accessing }
FlashcardsProbabilityLeitnerSystem >> numberOfBoxes [
	^ boxes size
]

{ #category : #public }
FlashcardsProbabilityLeitnerSystem >> pass: aFlashcard [ 
	selectedCard pass.
	  
]

{ #category : #public }
FlashcardsProbabilityLeitnerSystem >> pickRandomCard [
	| b filteredCards |
	b := self selectRandomBox.
	filteredCards := self allCards select: [ :c | c box = b ].
	^selectedCard := filteredCards atRandom 
]

{ #category : #public }
FlashcardsProbabilityLeitnerSystem >> processAnswer: anAnswer [
	"Check the answer and move the card forward if the answer is correct or move it backwards if the answer is wrong"
	anAnswer = selectedCard answer
		ifTrue: [ self moveSelectedCardForward ]
		ifFalse: [ self moveSelectedCardBackwards ]
]

{ #category : #public }
FlashcardsProbabilityLeitnerSystem >> removeCardAt: anIndex [
	boxes first removeAt: anIndex
	
]

{ #category : #public }
FlashcardsProbabilityLeitnerSystem >> removeCardNamed: aName ifAbsent: aBlock [
	^boxes removeCardNamed: aName ifAbsent: aBlock 
	
]

{ #category : #private }
FlashcardsProbabilityLeitnerSystem >> returnSelectedCard [
	"Put the selected card back in case you can't answer and want to pause"
	
	self selectedBox addCard: selectedCard.
]

{ #category : #private }
FlashcardsProbabilityLeitnerSystem >> selectRandomBox [
	| nonemptyBoxes scalingCoefficient sumOfProbabilities randomNumber scaledProbability selectedBox |
	"nonemptyBoxes := boxes reject: [ :box | box isEmpty ]".
	nonemptyBoxes := (self allCards inject: Set new into: [ :r :c | r add: c box; yourself ]).
	
	nonemptyBoxes ifEmpty: [
		Error signal: 'All boxes are empty' ].
	
	sumOfProbabilities := (nonemptyBoxes collect: [ :box | boxCumulativeProbabilities at: box ]) sum.
	scalingCoefficient := 1 / sumOfProbabilities.
	
	randomNumber := random next.
	
	selectedBox := nonemptyBoxes detect: [ :box |
		scaledProbability := (boxCumulativeProbabilities at: box) * scalingCoefficient.
		randomNumber <= scaledProbability ] ifNone: [ 1 ].
	
	^selectedBox.
]

{ #category : #accessing }
FlashcardsProbabilityLeitnerSystem >> selectedBox [
	^ boxes at: selectedBoxNumber 
]

{ #category : #accessing }
FlashcardsProbabilityLeitnerSystem >> selectedBoxNumber [
	^selectedBoxNumber 
]

{ #category : #accessing }
FlashcardsProbabilityLeitnerSystem >> selectedCard [
	^ selectedCard
]

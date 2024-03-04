Class {
	#name : #FlashcardsProbabilityLeitnerSystem,
	#superclass : #Object,
	#instVars : [
		'boxes',
		'random',
		'boxCumulativeProbabilities',
		'selectedBoxNumber',
		'selectedCard'
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
	"The new card always goes into the first box"
	boxes first addCard: aCard.
]

{ #category : #public }
FlashcardsProbabilityLeitnerSystem >> allCards [

	^boxes inject: OrderedCollection new into: [ :result  :box | result addAll: box cards; yourself ]
]

{ #category : #accessing }
FlashcardsProbabilityLeitnerSystem >> boxes [
	^ boxes
]

{ #category : #initialization }
FlashcardsProbabilityLeitnerSystem >> initialize [ 
	super initialize.
	random := Random new.
	
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
	aCollectionOfProbabilities size timesRepeat: [ boxes add: FlashcardList new ].
	
	sum := 0.
	boxCumulativeProbabilities := Dictionary new.
	
	aCollectionOfProbabilities withIndexDo: [ :probability :i |
		sum := sum + probability.
		boxCumulativeProbabilities at: (boxes at: i) put: sum ].
]

{ #category : #private }
FlashcardsProbabilityLeitnerSystem >> moveSelectedCardBackwards [
	"This happens if the answer was wrong. The card is moved back to the first box"
	boxes first addCard: selectedCard.
]

{ #category : #private }
FlashcardsProbabilityLeitnerSystem >> moveSelectedCardForward [
	"This happens if the answer is correct. The card should progress to the next box. And if it was already taken from the last box, it is put back into the last box"
	| nextBoxNumber |
	
	nextBoxNumber := selectedBoxNumber = boxes size
		ifTrue: [ selectedBoxNumber ]
		ifFalse: [ selectedBoxNumber + 1].
		
	(boxes at: nextBoxNumber) addCard: selectedCard.
]

{ #category : #accessing }
FlashcardsProbabilityLeitnerSystem >> numberOfBoxes [
	^ boxes size
]

{ #category : #public }
FlashcardsProbabilityLeitnerSystem >> pickRandomCard [
	self selectRandomBox.
	^selectedCard := (boxes at: selectedBoxNumber) pickRandomCard.
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
	nonemptyBoxes := boxes reject: [ :box | box isEmpty ].
	
	nonemptyBoxes ifEmpty: [
		Error signal: 'All boxes are empty' ].
	
	sumOfProbabilities := (nonemptyBoxes collect: [ :box | boxCumulativeProbabilities at: box ]) sum.
	scalingCoefficient := 1 / sumOfProbabilities.
	
	randomNumber := random next.
	
	selectedBox := nonemptyBoxes detect: [ :box |
		scaledProbability := (boxCumulativeProbabilities at: box) * scalingCoefficient.
		randomNumber <= scaledProbability ] ifNone: [ nonemptyBoxes first ].
	
	selectedBoxNumber := boxes indexOf: selectedBox.
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

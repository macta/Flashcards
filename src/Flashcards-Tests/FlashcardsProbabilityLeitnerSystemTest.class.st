"
A FlashcardsLeitnerSystemTest is a test class for testing the behavior of FlashcardsLeitnerSystem
"
Class {
	#name : #FlashcardsProbabilityLeitnerSystemTest,
	#superclass : #TestCase,
	#category : #'Flashcards-Tests'
}

{ #category : #tests }
FlashcardsProbabilityLeitnerSystemTest >> testDefaultProbabilities [

	| fls results topSelection |
	
	fls := FlashcardsProbabilityLeitnerSystem withProbabilities: #(0.5 0.25 0.125).
	
	1 to: 3 do: [ :i | fls addCard: (Flashcard question: i answer: i) ].
	
	results := Bag new.
	
	1000 timesRepeat: [ 
		results add: fls selectRandomCard.
		fls processAnswer: 'wrong anser'].
	
	topSelection := results sortedCounts first.
	
	self assert: topSelection key > 300 description: 'Should be about 1/3 of the values'.
	self assert: topSelection key < 400 description: 'Should be about 1/3 of the values'.
	
	
		
	

]

{ #category : #tests }
FlashcardsProbabilityLeitnerSystemTest >> testEarlierBoxesMoreProbableToGetPicked [

	| fls card1 card2 card3 results topSelection |
	
	fls := FlashcardsProbabilityLeitnerSystem withProbabilities: #(0.7 0.2 0.1).
	
	card1 := Flashcard question: 1 answer: 1.
	card2 := Flashcard question: 2 answer: 2.
	card3 := Flashcard question: 3 answer: 3.
		
		
	"sneaky way to setup boxes in known state"
	{card1. card2. card3} doWithIndex: [ :item :i |
		(fls boxes at: i) addCard: item ].
	
	results := Bag new.
	
	10000 timesRepeat: [ 
		results add: fls selectRandomCard.
		fls returnSelectedCard  ].

	topSelection := results cumulativeCounts first.
	
	"results cumulativeCounts inspect."
	self assert: topSelection value equals: card1.
	
		
	

]

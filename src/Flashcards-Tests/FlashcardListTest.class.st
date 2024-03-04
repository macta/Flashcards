Class {
	#name : #FlashcardListTest,
	#superclass : #TestCase,
	#category : #'Flashcards-Tests'
}

{ #category : #tests }
FlashcardListTest >> testAddCard [
	| box card |
	box := FlashcardList new.
	card := ('bonjour' -> 'hello') asFlashcard.
	
	self assert: box numberOfCards equals: 0.
	box addCard: card.
	
	self assert: box numberOfCards equals: 1.
]

{ #category : #tests }
FlashcardListTest >> testPromotingCardsToNextBox [
	| box card1 card2 selectedCard1 selectedCard2 |
	
	box := FlashcardList new.
	card1 := ('bonjour1' -> 'hello1') asFlashcard.
	card2 := ('bonjour2' -> 'hello2') asFlashcard.
	
	self assert: box numberOfCards equals: 0.
	self assert: box numberOfBoxes equals: 0.
	
	box addCards: {card1.card2}.
	
	self assert: box availableBoxes equals: {1} asSortedCollection.
	
	selectedCard1 := box pickRandomCard.
	selectedCard1 pass.
	
	self assert: box availableBoxes equals: {1. 2} asSortedCollection.
	
	selectedCard2 := box pickRandomCardSelectingFrom: [:c | c box = 1 ].
	selectedCard2 pass.
	
	self assert: box availableBoxes equals: {2} asSortedCollection.
]

{ #category : #tests }
FlashcardListTest >> testPromotingCardsToNextPreviousBox [
	| box card1 card2 selectedCard1 selectedCard2 |
	box := FlashcardList new.
	card1 := ('bonjour1' -> 'hello1') asFlashcard.
	card2 := ('bonjour2' -> 'hello2') asFlashcard.
	
	self assert: box numberOfCards equals: 0.
	self assert: box numberOfBoxes equals: 0.
	
	box addCards: {card1.card2}.
	
	self assert: box availableBoxes equals: {1} asSortedCollection.
	
	selectedCard1 := box pickRandomCard.
	selectedCard1 pass.
	
	self assert: box availableBoxes equals: {1. 2} asSortedCollection.
	
	selectedCard2 := box pickRandomCardFromBox: 1.
	selectedCard2 pass.
	
	self assert: box availableBoxes equals: {2} asSortedCollection.
	
	selectedCard1 fail.
	
	self assert: box availableBoxes equals: {1. 2} asSortedCollection.
	
	selectedCard2 fail.
	
	self assert: box availableBoxes equals: {1} asSortedCollection.
]

{ #category : #tests }
FlashcardListTest >> testTakeRandomCard [
	| box card1 card2 randomCard |
	
	box := FlashcardList new.
	card1 := ('bonjour' -> 'hello') asFlashcard.
	card2 := ('merci' -> 'thank you') asFlashcard.
	
	box
		addCard: card1;
		addCard: card2.
	
	randomCard := box pickRandomCard.
	
	self assert: (randomCard = card1 or: [ randomCard = card2 ]).
	
	
]

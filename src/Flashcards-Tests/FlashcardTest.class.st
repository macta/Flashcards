Class {
	#name : #FlashcardTest,
	#superclass : #TestCase,
	#category : #'Flashcards-Tests'
}

{ #category : #tests }
FlashcardTest >> testAsFlashcard [
	| card |
	card := ('bonjour' -> 'hello') asFlashcard.
	
	self assert: card question equals: 'bonjour'.
	self assert: card answer equals: 'hello'.
]

{ #category : #tests }
FlashcardTest >> testDemote [
	| card1 |
	
	card1 := ('bonjour' -> 'hello') asFlashcardInBox: 2.
	
	self assert: card1 box equals: 2.
	
	card1 fail.
	
	self assert: card1 box equals: 1.
	
	card1 fail.
	card1 fail.	
	
	self assert: card1 box equals: 1.
]

{ #category : #tests }
FlashcardTest >> testEquality [
	| card1 card2 card3 card4 |
	
	card1 := ('bonjour' -> 'hello') asFlashcard.
	card2 := ('bonjour' -> 'hello') asFlashcard. "same as card1"
	card3 := ('salut' -> 'hello') asFlashcard. "different word"
	card4 := ('bonjour' -> 'good morning') asFlashcard. "different translation"
	
	self assert: card2 equals: card1.
	self deny: card3 equals: card1.
	self deny: card4 equals: card1.
]

{ #category : #tests }
FlashcardTest >> testHash [
	| card1 card2 card3 card4 |
	
	card1 := ('bonjour' -> 'hello') asFlashcard.
	card2 := ('bonjour' -> 'hello') asFlashcard. "same as card1"
	card3 := ('salut' -> 'hello') asFlashcard. "different word"
	card4 := ('bonjour' -> 'good morning') asFlashcard. "different translation"
	
	self assert: card2 hash equals: card1 hash.
	self deny: card3 hash equals: card1 hash.
	self deny: card4 hash equals: card1 hash.
]

{ #category : #tests }
FlashcardTest >> testLessThanEqual [
	| card1 card2 card3 card4 |
	
	card1 := ($1 -> $1) asFlashcard.
	card2 := ($2 -> $2) asFlashcard. 
	(card3 := ($2 -> $2) asFlashcard) pass.
	card4 := ($3 -> $3) asFlashcard.
	
	self assert: card1 <= card1.
	self assert: card1 <= card2.
	
	card2 pass.
	
	self assert: card1 <= card3.
	self assert: card2 <= card3.
	self assert: card4 <= card3.
	
	
	
]

{ #category : #tests }
FlashcardTest >> testMatches [
	| card1 |
	
	card1 := ('bonjour' -> 'hello') asFlashcard.
	
	self assert: (card1 matches: card1 answer).
	self deny: (card1 matches: 'nothing')
]

{ #category : #tests }
FlashcardTest >> testProgressValue [
	| card1 card2 card3 |
	
	card1 := '1' asFlashcardInBox: 1.
	card2 := '2' asFlashcardInBox: 3.
	card3 := '3' asFlashcardInBox: 2.
	
	self assert: (card1 progressValueScaledBy: 3) equals: 0.
	self assert: (card2 progressValueScaledBy: 3) equals: 1.
	self assert: (card3 progressValueScaledBy: 4) equals: 1/3.
	self assert: (card3 progressValueScaledBy: 3) equals: 1/2.
]

{ #category : #tests }
FlashcardTest >> testPromote [
	| card1 |
	
	card1 := ('bonjour' -> 'hello') asFlashcard.
	
	self assert: card1 box equals: 1.
	
	card1 pass.
	
	self assert: card1 box equals: 2.
]

{ #category : #tests }
FlashcardTest >> testWordTranslation [
	| card |
	card := Flashcard question: 'bonjour' answer: 'hello'.
	
	self assert: card question equals: 'bonjour'.
	self assert: card answer equals: 'hello'.
]

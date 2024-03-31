Class {
	#name : #Flashcard,
	#superclass : #Object,
	#instVars : [
		'box',
		'answer',
		'question'
	],
	#category : #'Flashcards-Models'
}

{ #category : #'as yet unclassified' }
Flashcard class >> question: aWord answer: anAnswer [
	^ self new
		initializeQuestion: aWord answer: anAnswer;
		yourself
]

{ #category : #comparing }
Flashcard >> <= anObject [
	anObject class = self class
		ifFalse: [ ^ false ].
		
	^ (self box <= anObject box) or: [self question <= anObject question ]
]

{ #category : #comparing }
Flashcard >> = anObject [
	anObject class = self class
		ifFalse: [ ^ false ].
		
	^ anObject question = question and: [
		anObject answer = answer ].
]

{ #category : #accessing }
Flashcard >> answer [
	^ answer
]

{ #category : #accessing }
Flashcard >> box [

	^ box ifNil: [ box := 1 ] 
]

{ #category : #accessing }
Flashcard >> box: anObject [

	box := anObject
]

{ #category : #api }
Flashcard >> fail [
	"demote the card by reducing its box up to 1"
	
	self box: (self box - 1 max: 1).
	^self
]

{ #category : #testing }
Flashcard >> hasLowestBoxValue [
	^self box < 2
	
]

{ #category : #testing }
Flashcard >> hasReachedBoxLimit: aNumber [
	^self box >= aNumber
]

{ #category : #comparing }
Flashcard >> hash [
	^ question hash bitXor: answer hash
]

{ #category : #testing }
Flashcard >> ifNull: aBlock [
	^self
]

{ #category : #initialization }
Flashcard >> initializeQuestion: aQuestion answer: anAnswer [

	question := aQuestion.
	answer := anAnswer
]

{ #category : #testing }
Flashcard >> isNull [
	^false
]

{ #category : #comparing }
Flashcard >> matches: anObject [
	^ self answer = anObject 
]

{ #category : #api }
Flashcard >> pass [
	"advance the card in its box"
	
	self box: self box + 1.
	^self
]

{ #category : #printing }
Flashcard >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPutAll: '(word: ';
		print: question;
		nextPutAll: ', box: ';
		print: self box;
		nextPut: $)
]

{ #category : #api }
Flashcard >> progressValueScaledBy: anIntegerBoxCount [ 
	"Answer the value score for this cards progress - 1 is the max score achieved if the card reaches the boxCount"
	
	^(self box - 1) / (anIntegerBoxCount - 1)
]

{ #category : #accessing }
Flashcard >> question [
	^ question
]

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

{ #category : #'as yet unclassified' }
Flashcard >> fail [
	self box: (self box - 1 max: 1)
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

{ #category : #accessing }
Flashcard >> matches: anObject [
	^ self answer = anObject 
]

{ #category : #'as yet unclassified' }
Flashcard >> pass [
	self box: self box + 1
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

{ #category : #accessing }
Flashcard >> progressValue [
	^1
]

{ #category : #accessing }
Flashcard >> question [
	^ question
]

Class {
	#name : #NullFlashcard,
	#superclass : #Object,
	#classVars : [
		'Singleton'
	],
	#category : #'Flashcards-Models'
}

{ #category : #'instance creation' }
NullFlashcard class >> singleton [ 
	^ Singleton ifNil: [ Singleton := self new ]
]

{ #category : #accessing }
NullFlashcard >> ifNull: aBlock [
	^aBlock value
]

{ #category : #accessing }
NullFlashcard >> isNull [
	^true
]

{ #category : #accessing }
NullFlashcard >> progressValue [
	^0
]

{ #category : #accessing }
NullFlashcard >> question [
	^ 'null'
]

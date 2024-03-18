Extension { #name : #String }

{ #category : #'*Flashcards' }
String >> asFlashcard [
	^ Flashcard question: self answer: self
]

{ #category : #'*Flashcards' }
String >> asFlashcardInBox: aNumber [

	^ self asFlashcard
		  box: aNumber;
		  yourself
]

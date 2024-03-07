Extension { #name : #Association }

{ #category : #'*Flashcards' }
Association >> asFlashcard [
	^ Flashcard question: key answer: value.
]

{ #category : #'*Flashcards' }
Association >> asFlashcardInBox: anInteger [

	^ self asFlashcard
		  box: anInteger;
		  yourself
]

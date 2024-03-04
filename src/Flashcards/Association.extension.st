Extension { #name : #Association }

{ #category : #'*Flashcards' }
Association >> asFlashcard [
	^ Flashcard question: key answer: value.
]

//
//  AddBookView.swift
//  Bookworm
//
//  Created by Bogdan Orzea on 2022-10-04.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss

    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""

    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of the book", text: $title)
                    TextField("Author's name", text: $author)
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }

                Section {
                    TextEditor(text: $review)
                    RatingView(rating: $rating)
                } header: {
                    Text("Add a review")
                }

                Section {
                    Button("Save") {
                        let book = Book(context: moc)

                        book.id = UUID()
                        book.title = title
                        book.author = author
                        book.review = review
                        book.genre = genre
                        book.rating = Int16(rating)
                        book.date = Date.now

                        try? moc.save()

                        dismiss()
                    }
                    .disabled(isButtonDisabled)
                }
            }.navigationTitle("Add a book")
        }
    }

    var isButtonDisabled: Bool {
        title.isEmpty || author.isEmpty
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}

//
//  SwiftUIView.swift
//  Bookworm
//
//  Created by Bogdan Orzea on 2022-10-05.
//

import SwiftUI

struct DetailViewModel: View {
    let book: Book
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State private var showDeleteAlert = false
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .bottomTrailing) {
                Image(book.genre ?? "Fantasy")
                    .resizable()
                    .scaledToFit()
                
                Text(book.genre?.uppercased() ?? "FANTASY")
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(8)
                    .foregroundColor(.white)
                    .backgroundStyle(.black.opacity(0.75))
                    .clipShape(Capsule())
                    .offset(x: -5, y: -5)
            }
            
            Text(book.author ?? "Unknown author")
                .font(.title)
                .foregroundColor(.secondary)
            
            Text(book.date?.formatted(.dateTime.weekday(.wide).day().month().year()) ?? "Unknown date")
                .foregroundColor(.secondary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                RatingView(rating: .constant(Int(book.rating)))
                    .font(.largeTitle)
                
                Text(book.review ?? "No review")
                    .padding()
        }
        .navigationTitle(book.title ?? "Unknown book")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete book?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteBook)
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure?")
        }
        .toolbar {
            Button {
                showDeleteAlert = true
            } label: {
                Label("Delete this book", systemImage: "trash")
            }
        }
    }
    
    func deleteBook() {
        moc.delete(book)
        
        try? moc.save()
        
        dismiss()
    }
}

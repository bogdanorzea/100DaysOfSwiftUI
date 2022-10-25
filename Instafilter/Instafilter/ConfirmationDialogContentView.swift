//
//  ContentView.swift
//  Instafilter
//
//  Created by Bogdan Orzea on 2022-10-16.
//

import SwiftUI

struct ConfirmationDialogContentView: View {
    @State private var blurAmount = 0.0
    @State private var showConfirmation = false
    @State private var backgroundColor = Color.white
    
    var body: some View {
        VStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
            }
            .background(backgroundColor)
            .padding()
            .onTapGesture {
                showConfirmation = true
            }
            .blur(radius: blurAmount)
            
            Slider(value: $blurAmount, in: 0...10)
            
            Button("Random") {
                blurAmount = Double.random(in: 0...10)
            }
        }
        .onChange(of: blurAmount) { newValue in
            print(newValue)
        }
        .confirmationDialog("Pick a color", isPresented: $showConfirmation) {
            Button("Red") { backgroundColor = .red }
            Button("Blue") { backgroundColor = .blue }
            Button("Green") { backgroundColor = .green }
            
            Button("Cancel", role: .cancel) {}
        }
    }
}

struct ConfirmationDialogContentView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationDialogContentView()
    }
}

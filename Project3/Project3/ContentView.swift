//
//  ContentView.swift
//  Project3
//
//  Created by Bogdan Orzea on 2022-05-08.
//

import SwiftUI

struct ContentView: View {
    let motto1 = Text("Draco dormiens")
    var motto2: some View {
        Text("nunquam titillandus")
    }
    @ViewBuilder var spells: some View {
        Text("Lumos")
        Text("Obliviate")
    }
    
    @ViewBuilder var body: some View {
        VStack {
            Button("Hello, world!") {
                print(type(of: self.body))
            }
                .frame(width: 200, height: 200)
                .background(.red)
            
            Text("Hello, world!")
                .padding()
                .background(.red)
                .padding()
                .background(.blue)
                .padding()
                .background(.green)
                .padding()
                .background(.yellow)
            
            VStack {
                Text("Gryffindor")
                    .font(.largeTitle)
                Text("Hufflepuff")
            }
                .font(.title)

            VStack {
                motto1
                motto2
            }

            spells

            Text("Hello World")
                .titleStyle()
            
            Text("Large Hello World")
                .largeTitleStyle()
        }
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct LargeTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}

extension View {
    func largeTitleStyle() -> some View {
        modifier(LargeTitle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

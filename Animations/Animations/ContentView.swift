//
//  ContentView.swift
//  Animations
//
//  Created by Bogdan Orzea on 2022-06-20.
//

import SwiftUI

struct ContentView: View {
// 1
//    @State private var animationAmount = 1.0
// 3
//    @State private var animationAmount = 0.0
    
// 4
    @State private var enabled = true

    var body: some View {
// 1
//        Button("Tap me") {
////            animationAmount += 1
//        }
//            .padding(50)
//            .background(.red)
//            .foregroundColor(.white)
//            .clipShape(Circle())
//            .overlay(
//                Circle()
//                    .stroke(.red)
//                    .scaleEffect(animationAmount)
//                    .opacity(2-animationAmount)
//                    .animation(.easeOut(duration: 1).repeatForever(autoreverses: true), value: animationAmount)
//            )
//            .onAppear {
//                animationAmount = 2
//            }
//        print (animationAmount)
//
//        return VStack {
//            Stepper("Scale amount", value: $animationAmount.animation(), in: 1...10)
//
//            Spacer()
//
//2
//            Button("Tap Me") {
//                animationAmount += 1
//            }
//            .padding(40)
//            .background(.red)
//            .foregroundColor(.white)
//            .clipShape(Circle())
//            .scaleEffect(animationAmount)
//        }
        
// 3
//        Button("Tap Me") {
//            withAnimation(.linear(duration: 2)) {
//                animationAmount += 360
//            }
//        }
//        .padding(50)
//        .background(.red)
//        .foregroundColor(.white)
//        .clipShape(Circle())
//        .rotation3DEffect(.degrees(animationAmount), axis: (x:0, y:1, z:0))
        
        Button("Tap Me") {
            enabled.toggle()
        }
            .frame(width: 200, height: 200)
            .background(enabled ? .blue : .red)
            .animation(nil, value: enabled)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
            .animation(.interpolatingSpring(stiffness: 10, damping: 1), value: enabled)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

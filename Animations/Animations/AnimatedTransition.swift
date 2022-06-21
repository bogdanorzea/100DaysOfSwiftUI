//
//  AnimatedTransition.swift
//  Animations
//
//  Created by Bogdan Orzea on 2022-06-20.
//

import SwiftUI

struct AnimatedTransition: View {
    @State private var isShowingRed = false
    
    var body: some View {
        VStack {
            Button("Tap me") {
                withAnimation {
                    isShowingRed.toggle()
                }
            }
            
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
//                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
                    .transition(.pivot)
            }
        }
    }
}

struct AnimatedTransition_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedTransition()
    }
}

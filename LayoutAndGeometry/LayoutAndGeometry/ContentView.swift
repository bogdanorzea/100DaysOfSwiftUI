//
//  ContentView.swift
//  LayoutAndGeometry
//
//  Created by Bogdan Orzea on 2023-08-22.
//

import SwiftUI

extension VerticalAlignment {
    enum MidAccountAndName: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[.top]
        }
    }
    
    static let midAccountAndName = VerticalAlignment(MidAccountAndName.self)
}

//struct OuterView: View {
//    var body: some View {
//        VStack {
//            Text("Top")
//            InnerView()
//                .background(.green)
//            Text("Bottom")
//        }
//    }
//}
//
//struct InnerView: View {
//    var body: some View {
//        HStack {
//            Text("Left")
//            GeometryReader { geo in
//                Text("Center")
//                    .background(.blue)
//                    .onTapGesture {
//                        print("Global center: \(geo.frame(in: .global).midX) x \(geo.frame(in: .global).midY)")
//                        print("Local center: \(geo.frame(in: .local).midX) x \(geo.frame(in: .local).midY)")
//                        print("Custom center: \(geo.frame(in: .named("Custom")).midX) x \(geo.frame(in: .named("Custom")).midY)")
//                    }
//            }
//                .background(.orange)
//            Text("Right")
//        }
//    }
//}


//struct ContentView: View {
//    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]
//
//    var body: some View {
//        HStack(alignment: .midAccountAndName) {
//            VStack {
//                Text("@twostraws")
//                    .alignmentGuide(.midAccountAndName) { d in d[VerticalAlignment.center] }
//                Image(systemName: "globe")
//                    .resizable()
//                    .frame(width: 64, height: 64)
//            }
//
//            VStack {
//                Text("Full name:")
//                Text("PAUL HUDSON")
//                    .alignmentGuide(.midAccountAndName) { d in d[VerticalAlignment.center] }
//                    .font(.largeTitle)
//            }
//        }
//
//        Text("Hello, world!")
//            .offset(x: 100, y: 100)
//            .background(.red)
        
//        VStack {
//            GeometryReader { geo in
//                Text("Hello, world!")
//                    .frame(width: geo.size.width*0.9)
//                    .background(.red)
//            }
//                .background(.green)
//
//            Text("More")
//                .background(.blue)
//        }
        
//        OuterView()
//            .background(.red)
//            .coordinateSpace(name: "Custom")

//        GeometryReader { fullView in
//            ScrollView {
//                ForEach(0..<50) { index in
//                    GeometryReader { proxy in
//                        Text("Row #\(index)")
//                            .font(.title)
//                            .frame(maxWidth: .infinity)
//                            .background(colors[index % 7])
//                            .rotation3DEffect(.degrees((proxy.frame(in: .global).minY - fullView.size.height / 2) / 5, axis: (x: 0, y: 1, z: 0)))
//                    }
//                    .frame(height: 40)
//                }
//            }
//        }
//    }
//
//}

//struct ContentView: View {
//    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]
//
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 0) {
//                ForEach(1..<20) { num in
//                    GeometryReader { geo in
//                        Text("Number \(num)")
//                            .font(.largeTitle)
//                            .padding()
//                            .background(.red)
//                            .rotation3DEffect(.degrees(-geo.frame(in: .global).minX) / 8, axis: (x: 0, y: 1, z: 0))
//                    }
//                    .frame(width: 200, height: 200)
//                }
//            }
//        }
//    }
    
//    var body: some View {
//        Text("Hello, World")
//            .offset(x: 100, y: 100)
//            .background(.red)
//    }
    
//    var body: some View {
//        OuterView()
//            .background(.red)
//            .coordinateSpace(name: "Custom")
//    }
//}

extension Comparable {
    func clamped(range: ClosedRange<Self>) -> Self {
        return max(range.lowerBound, min(self, range.upperBound))
    }
}

struct ContentView: View {
    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]

    var body: some View {
        GeometryReader { fullView in
            ScrollView(.vertical) {
                let cardHeight: Double = 40
                
                ForEach(0..<50) { index in
                    GeometryReader { geo in
                        let minY = geo.frame(in: .global).minY
                        let fullViewHeight = fullView.size.height
                        let color = colors[index % 7]
                        
                        Text("Row #\(index)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .background(Color(hue: (minY / fullViewHeight).clamped(range: 0...1), saturation: 1.0, brightness: 1.0))
                            .rotation3DEffect(.degrees(minY - fullViewHeight / 2) / 5, axis: (x: 0, y: 1, z: 0))
                            .opacity(minY < 200 ? minY / 200 : 1.0)
                            .scaleEffect((2 * minY / fullViewHeight).clamped(range: 0.5...2))
                    }
                    .frame(height: cardHeight)
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  ContentView.swift
//  Drawing
//
//  Created by Bogdan Orzea on 2022-09-09.
//

import SwiftUI


// MARK: Shapes
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}

struct Arc: InsettableShape {
    let startAngle: Angle
    let endAngle: Angle
    let clockwise: Bool
    var insetAmount = 0.0
    
    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment
        
        var path = Path()
        
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width/2 - insetAmount, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)
    
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        
        return arc
    }
}

struct ShapesContentView: View {
    var body: some View {
        VStack {
            Triangle()
                .stroke(.red, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                .frame(width: 150, height: 150)

            Arc(startAngle: .degrees(0), endAngle: .degrees(150), clockwise: true)
                .stroke(.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                .frame(width: 150, height: 150)

            Circle()
                .strokeBorder(.blue, lineWidth: 40)
                .frame(width: 150, height: 150)

            Arc(startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: true)
                .strokeBorder(.blue, lineWidth: 40)
                .frame(width: 150, height: 150)
        }
    }
}

// MARK: - Flower
struct Flower: Shape {
    let petalOffset: Double
    let petalWidth: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()

        for i in stride(from: 0, to: Double.pi * 2, by: Double.pi / 8) {
            let rotation = CGAffineTransform(rotationAngle: i)
            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width/2, y: rect.height/2))

            let petal = Path(ellipseIn: CGRect(x: petalOffset, y: 0, width: petalWidth, height: rect.width / 2))

            let rotatedPetal = petal.applying(position)

            path.addPath(rotatedPetal)
        }

        return path
    }
}

struct FlowerContentView: View {
    @State private var petalOffset = -20.0
    @State private var petalWidth = 40.0
    
    var body: some View {
        VStack {
            Spacer()
            
            Flower(petalOffset: petalOffset, petalWidth: petalWidth)
                .fill(.red, style: FillStyle(eoFill: true))
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Petal offset")
                Slider(value: $petalOffset, in: -40...80)
                Text("Petal width")
                Slider(value: $petalWidth, in: 0...100)
            }
            .padding()
        }
    }
}

// MARK: - Colors
struct ColorCyclingView: View {
    var amount: Double = 0.0
    private let steps = 100
    
    var body: some View {
        ZStack {
            ForEach(0..<steps, id: \.self) { value in
                Circle()
                    .inset(by: Double(value))
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                color(for: value, brightness: 1),
                                color(for: value, brightness: 0.5),
                            ],
                           startPoint: .top,
                           endPoint: .bottom
                          ),
                        lineWidth: 2
                    )
            }
        }
        .drawingGroup() // renders the view off-screen for better performance
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(steps) + amount
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct ColorContentView: View {
    @State private var colorCycle = 0.0
    
    var body: some View {
        VStack {
            Spacer()
            
            ColorCyclingView(amount: colorCycle)
                .frame(width: 300, height: 300)
            
            Spacer()
            
            Slider(value: $colorCycle)
        }
    }
}


// MARK: - Special effects
struct Colors: View {
    @State private var amount = 0.1
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(.red)
                    .frame(width: 200 * amount)
                    .offset(x: -50, y: 0)
                    .blendMode(.screen)
                
                Circle()
                    .fill(.green)
                    .frame(width: 200 * amount)
                    .offset(x: 50, y: 0)
                    .blendMode(.screen)
                
                Circle()
                    .fill(.blue)
                    .frame(width: 200 * amount)
                    .offset(x: 0, y: 80)
                    .blendMode(.screen)
                
            }
                .frame(width: 300, height: 300)
            
            Spacer()
                .frame(height: 50)

            Slider(value: $amount)
                .padding()
        }
        .frame(maxHeight: .infinity)
        .background(.black)
        .ignoresSafeArea(.all)
    }
}

// MARK: - Animated Shapes
struct Trapezoid: Shape {
    var insetAmount: Double
    
    var animatableData: Double {
        get { insetAmount }
        set { insetAmount = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        
        return path
    }
}

struct AnimatedShapesContentView: View {
    @State private var insetAmount: Double = 20.0
    
    var body: some View {
        VStack {
            Trapezoid(insetAmount: insetAmount)
                .frame(width: 200, height: 200)
                .onTapGesture {
                    withAnimation {
                        insetAmount = Double.random(in: 50...100)
                    }
                }
        }
    }
}

// MARK: - Animated Shapes
struct CheckerBoard: Shape {
    var rows: Int
    var columns: Int
    
    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(Double(rows), Double(columns)) }
        set {
            rows = Int(newValue.first)
            columns = Int(newValue.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let rowSize = rect.height / Double(rows)
        let columnSize = rect.width / Double(columns)
        
        for row in 0..<rows {
            for col in 0..<columns {
                if (row + col).isMultiple(of: 2) {
                    let startX = columnSize * Double(col)
                    let startY = rowSize * Double(row)
                    
                    let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
                    path.addRect(rect)
                }
            }
        }
        
        return path
    }
}

struct CheckerBoardContentView: View {
    @State private var rows = 4
    @State private var columns = 4
    
    var body: some View {
        CheckerBoard(rows: rows, columns: columns)
            .frame(width: 400, height: 400)
            .onTapGesture {
                withAnimation {
                    rows *= 2
                    columns *= 2
                }
            }
    }
}

// MARK: - Spirograph
struct Sprirograph: Shape {
    let innerRadius: Int
    let outerRadius: Int
    let distance: Int
    let amount: Double
    
    
    func path(in rect: CGRect) -> Path {
        let divisor = gcd(innerRadius, outerRadius)
        
        let innerRadius = Double(self.innerRadius)
        let outerRadius = Double(self.outerRadius)
        let distance = Double(self.distance)
        
        let difference = innerRadius - outerRadius
        let endPoint = ceil(2 * Double.pi * outerRadius / Double(divisor)) * amount
        
        var path = Path()
        
        for theta in stride(from: 0, through: endPoint, by: 0.1) {
            var x = difference * cos(theta) + distance * cos(difference / outerRadius * theta)
            var y = difference * sin(theta) - distance * sin(difference / outerRadius * theta)
            
            x += rect.width / 2
            y += rect.height / 2
            
            if theta == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path
    }
    
    func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a
        var b = b
        
        while b != 0 {
            let temp = b
            b = a % b
            a = temp
        }
        
        return a
    }
}

struct SpirographContentView: View {
    @State private var innerRadius = 125.0
    @State private var outerRadius = 75.0
    @State private var distance = 25.0
    @State private var amount = 1.0
    @State private var hue = 0.6

    
    var body: some View {
        VStack {
            Spacer()
            
            Sprirograph(
                innerRadius: Int(innerRadius),
                outerRadius: Int(outerRadius),
                distance: Int(distance),
                amount: amount
            )
                .stroke(Color(hue: hue, saturation: 1, brightness: 1), lineWidth: 1)
            
            Spacer()
            
            VStack {
                Text("Inner radius: \(Int(innerRadius))")
                Slider(value: $innerRadius, in: 10...150)
                
                Text("Outer radius: \(Int(outerRadius))")
                Slider(value: $outerRadius, in: 10...150)
                
                Text("Distance: \(Int(distance))")
                Slider(value: $distance, in: 1...150, step: 1)
                
                Text("Amount: \(amount, format: .number.precision(.fractionLength(2)))")
                Slider(value: $amount, in: 0...1)
            }.padding()
        }
    }
}

// MARK: - Arrow
struct Arrow: Shape {
    var tipWidth: Double
    var tipHeight: Double
    
    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(tipWidth, tipHeight)
        }
        set {
            tipWidth = newValue.first
            tipHeight = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: 0))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        
        path.move(to: CGPoint(x: rect.midX, y: 0))
        path.addLine(to: CGPoint(x: rect.midX - tipWidth/2, y: tipHeight/2))
        path.addLine(to: CGPoint(x: rect.midX + tipWidth/2, y: tipHeight/2))
        path.closeSubpath()
       
        return path
    }
}

struct ArrowContentView: View {
    @State private var tipWidth = 40.0
    @State private var tipHeight = 40.0
    @State private var thickness = 5.0

    var body: some View {
        VStack {
            Arrow(tipWidth: tipWidth, tipHeight: tipHeight)
                .stroke(lineWidth: thickness)
                .padding()
            
            Slider(value: $thickness, in: 1...10, step: 1)
                .padding()
            Slider(value: $tipWidth, in: 40...100)
                .padding()
            Slider(value: $tipHeight, in: 40...100)
                .padding()
            
            Button("Random 🎲") {
                withAnimation {
                    thickness = Double.random(in: 1...10)
                    tipWidth = Double.random(in: 40...100)
                    tipHeight = Double.random(in: 40...100)
                }
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        ArrowContentView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

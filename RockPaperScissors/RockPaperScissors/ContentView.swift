//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Bogdan Orzea on 2022-05-08.
//

import SwiftUI

struct ContentView: View {
    static let options: [GameChoice] = [.rock, .paper, .scissors]
    static let maxMoves: Int = 10

    @State var compSelected: GameChoice = options.randomElement()!
    @State var shuffledOptions: [GameChoice] = Self.options.shuffled()
    @State var shouldWin = Bool.random()
    @State var score: Int = 0
    @State var questionsShown: Int = 0
    @State var alertId: AlertId?

    var body: some View {
        ZStack {
            LinearGradient(colors: shouldWin ? [.white, .green] : [.white, .red], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack {
                Spacer()
                VStack(alignment: .center) {
                    HStack {
                        Text("I choose")
                        Text(compSelected.rawValue)
                            .fontWeight(.bold)
                        Text("!")
                    }
                    HStack {
                        Text("What to chose to")
                        Text(shouldWin ? "Win" : "Loose")
                            .fontWeight(.bold)
                        Text("?")
                    }
                }
                    .padding()
                    .font(.title)
                    .background(.thinMaterial)
                    .cornerRadius(16)
                    .shadow(radius: 4)

                Spacer()
                ForEach(shuffledOptions, id: \.self) { option in
                    Button(option.rawValue) {
                        userSelected(option, shouldWin: shouldWin)
                    }
                        .frame(minWidth: 100)
                        .padding()
                        .background(.black)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(radius: 4)
                }.padding()
                Spacer()
                VStack {
                    Text("Score: \(score)")
                        .fontWeight(.heavy)
                    Text("Question: \(questionsShown+1)/\(Self.maxMoves)")
                }
                .font(.headline)
                Spacer()
            }
            .alert(item: $alertId) { (alertId) -> Alert in
                return Alert(
                    title: Text(alertId.id.name),
                    dismissButton: Alert.Button.default(
                        Text("OK"),
                        action: {
                            if alertId.id == AlertId.AlertType.endGame {
                                endGame()
                            }
                        }
                    )
                )
            }
        }
    }

    func userSelected(_ option: GameChoice, shouldWin: Bool) {
        guard questionsShown + 1 < Self.maxMoves else {
            alertId = AlertId(id: .endGame)
            return
        }

        questionsShown += 1

        guard option != compSelected else {
            alertId = AlertId(id: .draw)
            newRound()
            return
        }

        var correctAnswer: GameChoice

        switch compSelected {
        case .rock:
            correctAnswer = shouldWin ? .paper : .scissors
        case .paper:
            correctAnswer = shouldWin ? .scissors : .rock
        case .scissors:
            correctAnswer = shouldWin ? .rock : .paper
        }

        if (correctAnswer == option) {
            score += 1
        } else {
            if (score >= 1) {
                score -= 1
            }
            alertId = AlertId(id: .lose)
        }

        newRound()
    }

    func newRound() {
        compSelected = Self.options.randomElement()!
        shuffledOptions.shuffle()
        shouldWin.toggle()
    }

    func endGame() {
        score = 0
        questionsShown = 0
        shouldWin.toggle()
        newRound()
    }
}

enum GameChoice: String {
    case rock = "Rock 🪨"
    case paper = "Paper 📄"
    case scissors = "Scissors ✂️"
}

struct AlertId: Identifiable {
    var id: AlertType

    enum AlertType {
        case endGame
        case lose
        case draw
    }
}

extension AlertId.AlertType {
    var name: String {
        switch self {
        case .endGame:
            return "Thanks for playing"
        case .lose:
            return "Nope! Try again"
        case .draw:
            return "Draw"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  ContentView.swift
//  HWS-Challenge-2-RockPaperScissors
//
//  Created by Vaibhav Ranga on 03/04/24.
//

import SwiftUI

enum Choices: CaseIterable {
    case Rock, Paper, Scissors
}

enum WinLoseDraw: String {
    case win, lose, draw
}

struct ContentView: View {
    @State private var appRandomChoice = Choices.allCases.randomElement()
    @State private var userHasToWin = true
    @State private var userChoice = Choices.Rock
    @State private var displayRestartAlert = false
    @State private var displayRulesAlert = false
    @State private var numberOfQuestions = 10
    @State private var score = 0
    
    private var choiceComparisonForUserWin: WinLoseDraw {
        
        switch(appRandomChoice) {
            
        case .Rock: if userChoice == .Rock {return .draw}
            else if userChoice == .Paper { return .win }
            else if userChoice == .Scissors {return .lose}
            
        case .Paper: if userChoice == .Rock {return .lose}
            else if userChoice == .Paper { return .draw }
            else if userChoice == .Scissors {return .win}
            
        case .Scissors: if userChoice == .Rock {return .win}
            else if userChoice == .Paper { return .lose }
            else if userChoice == .Scissors {return .draw}
            
        default: return .draw
        }
        
        return .draw
    }
    
    private var result: WinLoseDraw {
        let comparisonResult = choiceComparisonForUserWin
        
        if userHasToWin && comparisonResult.rawValue == "win" {
            return .win
        } else if userHasToWin && comparisonResult.rawValue == "lose" {
            return .lose
        } else if !userHasToWin && comparisonResult.rawValue == "win" {
            return .lose
        } else if !userHasToWin && comparisonResult.rawValue == "lose" {
            return .win
        }
        return .draw
    }
    
    var body: some View {
        
        ZStack(alignment: .topTrailing) {
            AngularGradient(colors: [.red, .green, .yellow, .cyan, .indigo, .pink], center: .center)
                .ignoresSafeArea()
            
            ZStack {
                Image(systemName: "questionmark.diamond")
                    .font(.title.bold())
                    .padding(.horizontal)
                    .onTapGesture {
                        displayRulesAlert = true
                    }
            }
            
            VStack {
                Spacer()
                Spacer()
                
                Text("Rock Paper Scissors Trainer")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    
                
                VStack(spacing: 15) {
                    Text("App Choice: \(appRandomChoice!)")
                        .font(.headline)
                    
                    Text("Play to \(userHasToWin ? "win" : "lose")")
                        .fontWeight(.bold)
                    
                    ForEach(Choices.allCases, id: \.self) { choice in
                        Button {
                            checkResult(for: choice)
                        } label: {
                            Text("\(choice)")
                                .font(.title)
                                .frame(width: 200, height: 60)
                                .background(.white)
                                .clipShape(.rect(cornerRadius: 10))
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.thinMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                
                Text("Score: \(score)")
                    .font(.headline)
                    .foregroundStyle(.indigo)
                Spacer()
            }
            .padding()
        }
        .alert("Game over", isPresented: $displayRestartAlert) {
            Button("Restart Game", action: {resetGame()})
        } message: {
            Text("You scored \(score)/\(10 - numberOfQuestions)")
        }
        
        .alert("Rules", isPresented: $displayRulesAlert) {
            Button("OK", action: {})
        } message: {
            Text("The objective of this game is to teach you the game of Rock-Paper-Scissors. You will be playing against your phone. The \"App Choice\" is your phone's pick for the current turn and you will be required to play the game either to win or lose as told by the game viz. \"Play to win\" by selecting one of the options: Rock, Paper or Scissors.")
        }
    }
    
    func checkResult(for choice: Choices) {
        userChoice = choice
        if result.rawValue == "win" {
            score += 1
        } else if result.rawValue == "lose" {
            score -= 1
        }
        
        numberOfQuestions -= 1
        if numberOfQuestions > 0 {
            newSet()
        } else {
            displayRestartAlert = true
        }
    }
    
    func newSet() {
        appRandomChoice = Choices.allCases.randomElement()
        userHasToWin.toggle()
    }
    
    func resetGame() {
        numberOfQuestions = 10
        score = 0
        newSet()
    }
}

#Preview {
    ContentView()
}

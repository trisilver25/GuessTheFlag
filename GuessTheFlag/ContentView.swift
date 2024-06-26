//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Tristin Smith on 6/1/24.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var msg = ""
    
    @State private var lastRound = false
    @State private var round = 0
    @State private var lastRoundTitle = ""
    
    @State private var animateCorrect = 0.0
    @State private var animateOpacity = 1.0
    @State private var besidesTheWrong = false
    @State private var besidesTheCorrect = false
    @State private var selectedFlag = 0
    
    struct FlagImage: View {
        var flagName: String
        
        var body: some View {
            Image(flagName)
                .clipShape(.capsule)
                .shadow(radius: 5)
        }
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            selectedFlag = number
                            
                            flagTapped(number)
                        } label: {
                            FlagImage(flagName: countries[number])
                        }
                        // Animate when user selects the correct button
                        .rotation3DEffect(
                            .degrees(number == correctAnswer ? animateCorrect : 0),
                                     axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                        .opacity(number != correctAnswer && besidesTheCorrect ? animateOpacity: 1)
                        // Animate when user selects the wrong button
                        .background(besidesTheWrong && selectedFlag == number ? Capsule(style: .circular).fill(Color.red).blur(radius: 30) : Capsule(style: .circular).fill(Color.clear).blur(radius: 0))
                        .opacity(besidesTheWrong && selectedFlag != number ? animateOpacity : 1)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
            .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                VStack {
                    Text("Score: \(score)")
                        .foregroundStyle(.white)
                    .font(.title.bold())
                    
                    Text("Round: \(round + 1)")
                        .foregroundStyle(.white)
                        .font(.title.bold())
                }
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
                Text("\(msg)")
        }
        .alert(lastRoundTitle, isPresented: $lastRound) {
            Button("Restart", action: reset)
        } message: {
            Text("\(msg)")
        }
    }
    
    func flagTapped(_ number: Int) {
        
        if round == 7 {
            if number == correctAnswer {
                score += 1
            }
            
            if score == 8 {
                lastRoundTitle = "Winner!"
                msg = "Perfect Score!"
            } else if score > 5 {
                lastRoundTitle = "So close!"
                msg = "Your score is \(score) out of 8"
            } else {
                lastRoundTitle = "Better luck next time"
                msg = "Your score is \(score) out of 8, practice makes perfect try again!"
            }
            
            lastRound = true
            
        } else if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            msg = "Your score is \(score)"
            
            round += 1
            showingScore = true
            
            withAnimation{
                animateCorrect += 360
                animateOpacity = 0.25
                besidesTheCorrect = true
            }
        } else {
            scoreTitle = "Wrong!"
            msg = "That's the flag of \(countries[number])"
            
            round += 1
            
            withAnimation {
                animateOpacity = 0.25
                besidesTheWrong = true
            }
            showingScore = true
        }
        
        
        
    }
    
    func askQuestion() {
        besidesTheCorrect = false
        besidesTheWrong = false
        countries.remove(at: correctAnswer)
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func reset() {
        score = 0
        round = 0
        countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"]
    }
}
#Preview {
    ContentView()
}

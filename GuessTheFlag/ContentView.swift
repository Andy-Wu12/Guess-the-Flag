//
//  ContentView.swift
//  Guess-the-Flag
//
//  Created by Andy Wu on 12/5/22.
//

import SwiftUI

let numFlags = 3

struct ContentView: View {
    // Animations
    @State private var guessed = false
    @State private var rotationAmount = Array(repeating: 0.0, count: numFlags)
    @State private var opacityLevel = Array(repeating: 1.0, count: numFlags)
    
    @State private var score = 0

    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US", "Argentina", "Brazil", "Canada", "Columbia", "Greece", "Japan", "Monaco", "South Korea", "Switzerland", "Ukraine"].shuffled()
    @State var correctAnswer = Int.random(in: 0...2)
    
    @State private var roundsPlayed = 0
    @State private var gameOver = false
    private let maxRounds = 10
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                Gradient.Stop(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                Gradient.Stop(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.5)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundColor(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button {
                            if !guessed {
                                flagTapped(number)
                            }
                        } label: {
                            FlagImage(countryName: countries[number])
                        }
                        .rotation3DEffect(
                            .degrees(rotationAmount[number]),
                            axis: (x: 0, y: 1, z: 0)
                        )
                        .opacity(opacityLevel[number])
                        .shadow(color: guessed ? (number == correctAnswer ? .green : .red) : .clear,
                                radius: 5)
                    }
                } .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                if guessed {
                    Button("Continue", action: askQuestion)
                        .foregroundColor(.black)
                        .font(.title.bold())
                }
                Spacer()
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            } .padding()
            
        }
        .alert("Game Over", isPresented: $gameOver) {
            Button("Restart", action: reset)
        } message: {
            Text("Your score was \(score) / \(maxRounds)")
        }
    }
    
    func flagTapped(_ number: Int) {
        withAnimation {
            rotationAmount[number] += 360
            for i in 0..<numFlags {
                if i != number {
                    opacityLevel[i] = 0.50
                }
            }
        }
        
        guessed = true
        if number == correctAnswer {
            score += 1
        }
    
        addRoundPlayed()
        // Reset animation values
        rotationAmount[number] = 0
    }
    
    func addRoundPlayed() {
        roundsPlayed += 1
        if roundsPlayed == maxRounds {
            gameOver = true
        }
    }
    
    func reset() {
        roundsPlayed = 0
        score = 0
        gameOver = false
        askQuestion()
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        // Reset opacity levels before asking next question
        opacityLevel = Array(repeating: 1.0, count: numFlags)
        guessed = false
    }
}

/// ViewsAndModifiers Challenge 2 - replace Image view used for flags
/// with a new FlagImage() view that renders one flag image using the specific set of modifiers we had
struct FlagImage: View {
    var countryName: String
    
    var body: some View {
        Image(countryName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

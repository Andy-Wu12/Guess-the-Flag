//
//  ContentView.swift
//  Guess-the-Flag
//
//  Created by Andy Wu on 12/5/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var score = 0
    @State private var scoreTitle = ""
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
                            flagTapped(number)
                        } label: {
                            FlagImage(countryName: countries[number])
                        }
                    }
                } .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            } .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }

        .alert("Game Over", isPresented: $gameOver) {
            Button("Restart", action: reset)
        } message: {
            Text("Your score was \(score) / \(maxRounds)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Incorrect. That is the flag of \(countries[number])"
        }
        showingScore = true
        addRoundPlayed()
    }
    
    func addRoundPlayed() {
        roundsPlayed += 1
        if roundsPlayed == maxRounds {
            showingScore = false // Prevents score update pop up if game is over
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

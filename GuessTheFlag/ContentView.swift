//
//  ContentView.swift
//  Guess-the-Flag
//
//  Created by Andy Wu on 12/5/22.
//

import SwiftUI

extension Color {
    var all: [Color] { return [.red, .yellow, .green, .blue, .purple, .red] }
}

struct ContentView: View {
    @State private var showingAlert = false
    
    var body: some View {
        AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center)
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

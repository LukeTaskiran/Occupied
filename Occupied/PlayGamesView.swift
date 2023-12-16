import SwiftUI

struct PlayGamesView: View {
    var body: some View {
        VStack {
            Text("Play Games")
                .font(.title)
                .foregroundColor(.blue)
                .padding()

            // Example: Display a list of games or game-related content
            List(["Chess", "Poker", "Scrabble", "Uno"], id: \.self) { game in
                Text(game)
            }
            .padding()
        }
    }
}

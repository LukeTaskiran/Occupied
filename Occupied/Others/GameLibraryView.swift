import SwiftUI

struct GameLibraryView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink(destination: MemoryMatchView(viewModel: MemoryMatchViewModel(difficulty: .easy, theme: .animals))) {
                    GameButton(title: "Memory Match")
                }

                NavigationLink(destination: PlayGamesView()) {
                    GameButton(title: "Tic Tac Toe")
                }

                NavigationLink(destination: PlayGamesView()) {
                    GameButton(title: "Checkers")
                }
            }
            .navigationBarTitle("Game Library")
            .padding()
        }
    }
}

struct GameButton: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}

struct GameLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        GameLibraryView()
    }
}


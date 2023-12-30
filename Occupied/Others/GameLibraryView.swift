import SwiftUI

struct GameLibraryView: View {
    @StateObject private var interstitialAdManager = InterstitialAdsView()

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                    NavigationLink(destination: MemoryMatchView(viewModel: MemoryMatchViewModel(difficulty: .easy, theme: .animals))) {
                        GameButton(title: "Memory Match")
                    }.simultaneousGesture(TapGesture().onEnded{
                        interstitialAdManager.displayInterstitialAd()                           })
                
                    
                    NavigationLink(destination: PlayGamesView()) {
                        GameButton(title: "Tic Tac Toe")
                    }.simultaneousGesture(TapGesture().onEnded{
                        interstitialAdManager.displayInterstitialAd()                           })
                
                    
                    
                        NavigationLink(destination: Checkers()) {
                            GameButton(title: "Checkers")
                        }.simultaneousGesture(TapGesture().onEnded{
                            interstitialAdManager.displayInterstitialAd()                           })
                    
                    SwiftUIBannerAd(adPosition: .bottom, adUnitId: "ca-app-pub-3940256099942544/2934735716")
                        .frame(height: 125,alignment: .center)
                        .padding()
                        
                }
            }
            .onAppear{
                        interstitialAdManager.loadInterstitialAd()
                    }
                    .disabled(!interstitialAdManager.interstitialAdLoaded)
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


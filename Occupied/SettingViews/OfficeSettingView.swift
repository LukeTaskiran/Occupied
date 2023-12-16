// OfficeSettingView.swift

import SwiftUI

struct OfficeSettingView: View {
    var body: some View {
        TabView {
            ChatWithAIView()
                .tabItem {
                    Image(systemName: "message")
                    Text("Chat with AI")
                }
                .tag(0)

            PlayGamesView()
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("Play Games")
                }
                .tag(1)
        }
        .navigationBarTitle("Office Setting", displayMode: .inline)
    }
}

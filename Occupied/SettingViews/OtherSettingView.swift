// OfficeSettingView.swift

import SwiftUI

struct OtherSettingView: View {
    var body: some View {
        TabView {
            ChatWithAIView()
                .tabItem {
                    Image(systemName: "message")
                    Text("Chat with AI")
                }
                .tag(0)

            
            MemoryMatchView(viewModel: MemoryMatchViewModel(difficulty: .medium, theme: .animals))
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("Play Games")
                }
                .tag(1)
        }
        .navigationBarTitle("Office Setting", displayMode: .inline)
    }
}

struct OtherSettingView_Previews: PreviewProvider {
    static var previews: some View {
        OtherSettingView()
    }
}

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

            GameLibraryView()
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("Game Library")
                }
                .tag(1)
            PhoneCallView()
                .tabItem {
                    Image(systemName: "phone.connection.fill")
                    Text("Fake Call")
                }
                .tag(2)
            
        }
        .navigationBarTitle("Office Setting", displayMode: .inline)
    }
}

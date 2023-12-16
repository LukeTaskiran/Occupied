// PartySettingView.swift

import SwiftUI

struct PartySettingView: View {
    var body: some View {
        TabView {
            ChatWithAIView()
                .tabItem {
                    Image(systemName: "message")
                    Text("Chat with AI")
                }
                .tag(0)
            
            NotificationsView()
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notifications")
                }
                .tag(1)
            
            WeatherView()
                .tabItem {
                    Image(systemName: "cloud.sun")
                    Text("Weather")
                }
                .tag(2)
            
            ImageMatchingView()
                .tabItem {
                    Image(systemName: "tortoise.fill")
                    Text("Endless Scroll")
                        .tag(3)
                }
                .navigationBarTitle("Party Setting", displayMode: .inline)
        }
    }
}

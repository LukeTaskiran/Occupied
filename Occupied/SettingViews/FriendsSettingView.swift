// OfficeSettingView.swift

import SwiftUI

struct FriendsSettingView: View {
    var body: some View {
        TabView {

            ImageMatchingView()
                .tabItem {
                    Image(systemName: "tortoise.fill")
                    Text("Endless Scroll")
                }
                .tag(0)
            NotificationsView()
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notifications")
                }
                .tag(1)
            GameLibraryView()
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("Game Library")
                }
                .tag(2)
        }
        .navigationBarTitle("Friends Setting", displayMode: .inline)
    }
}

// PartySettingView.swift

import SwiftUI

struct PartySettingView: View {
    var body: some View {
        TabView {
            PhoneCallView()
                .tabItem {
                    Image(systemName: "phone.connection.fill")
                    Text("Fake Call")
                }
                .tag(0)
            
            NotificationsView()
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notifications")
                }
                .tag(1)
                                
            ImageMatchingView()
                .tabItem {
                    Image(systemName: "tortoise.fill")
                    Text("Endless Scroll")
                }
                .tag(2)

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(3)
                }
                .navigationBarTitle("Party Setting", displayMode: .inline)
        }
    }


// OfficeSettingView.swift

import SwiftUI

struct OfficeSettingView: View {
    var body: some View {
        TabView {
            Notes()
                .tabItem {
                    Image(systemName: "message")
                    Text("Notes")
                }
                .tag(0)

            GameLibraryView()
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("Game Library")
                }
                .tag(1)
            
            CreativeFidgetView()
                .tabItem {
                    Image(systemName: "figure.run.circle.fill")
                    Text("Fidget")
                }
                .tag(2)
            PhoneCallView()
                .tabItem {
                    Image(systemName: "phone.connection.fill")
                    Text("Fake Call")
                }
                .tag(3)
            
        }
        .navigationBarTitle("Office Setting", displayMode: .inline)
    }
}

// NotificationsView.swift

import SwiftUI

struct NotificationsView: View {
    var body: some View {
        VStack {
            Text("Notifications Feature")
                .font(.title)
                .foregroundColor(.blue)
                .padding()

            // Example: Add your notifications components or list here
            NotificationsList()
        }
    }
}

struct NotificationsList: View {
    var body: some View {
        // Example: Your notifications list implementation
        List(["Notification 1", "Notification 2", "Notification 3"], id: \.self) { notification in
            Text(notification)
        }
        .padding()
    }
}

import SwiftUI
import UserNotifications

struct NotificationsView: View {
    @State private var selectedNotificationType: NotificationType = .scheduled
    @State private var notificationDate = Date()
    @State private var notificationHeader = "Busy Notification"
    @State private var notificationMessage = "Acting Busy at a Scheduled Time"
    @State private var showNotificationScheduled = false
    @State private var disableNotifications = false

    var body: some View {
        VStack {
            Text("Schedule a Notification")
                .font(.title)
                .padding()

            Picker("Notification Type", selection: $selectedNotificationType) {
                ForEach(NotificationType.allCases, id: \.self) { type in
                    Text(type.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if selectedNotificationType == .scheduled {
                DatePicker("Select Date", selection: $notificationDate, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .padding()
            }

            TextField("Notification Header", text: $notificationHeader)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Notification Message", text: $notificationMessage)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                withAnimation {
                    scheduleNotification()
                }
            }) {
                Text("Schedule Notification")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(disableNotifications)

            Spacer()

            if showNotificationScheduled {
                Text("Notification Scheduled!")
                    .foregroundColor(.green)
                    .transition(.opacity)
                    .animation(.easeInOut)
            }
        }
        .padding()
        .navigationTitle("Notification Scheduler")
    }

    private func scheduleNotification() {
        if disableNotifications {
            return
        }

        let content = UNMutableNotificationContent()
        content.title = notificationHeader
        content.body = notificationMessage
        content.sound = .default

        var trigger: UNNotificationTrigger
        switch selectedNotificationType {
        case .immediate:
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        case .scheduled:
            let components = Calendar.current.dateComponents([.hour, .minute], from: notificationDate)
            trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        case .spam:
            // Fix crash by using a longer time interval for spam
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        }

        let turnOffAction = UNNotificationAction(
            identifier: "TURN_OFF_ACTION",
            title: "Turn Off",
            options: []
        )

        let category = UNNotificationCategory(
            identifier: "CUSTOM_CATEGORY",
            actions: [turnOffAction],
            intentIdentifiers: [],
            options: []
        )

        UNUserNotificationCenter.current().setNotificationCategories([category])

        content.categoryIdentifier = "CUSTOM_CATEGORY"

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully!")
                self.showNotificationScheduled = true
            }
        }
    }
}

enum NotificationType: String, CaseIterable {
    case scheduled = "Scheduled"
    case immediate = "Immediate"
    case spam = "Spam"

    var notificationText: String {
        switch self {
        case .immediate:
            return "Acting Busy Immediately"
        case .scheduled:
            return "Acting Busy at a Scheduled Time"
        case .spam:
            return "Spamming Notifications"
        }
    }
}


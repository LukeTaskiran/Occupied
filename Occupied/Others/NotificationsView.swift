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

            Text("Modify the message you wish to receive")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(8)
            
            Text("Header:").multilineTextAlignment(.leading).padding(.top,5)
            TextField("Notification Header", text: $notificationHeader)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Text("Paragraph:")
                .multilineTextAlignment(.leading)
            TextField("Notification Message", text: $notificationMessage)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom,10)

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
        }

        // Calculate the total duration for which spam notifications will be scheduled
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
    case immediate = "Celebrity"


    var notificationText: String {
        switch self {
        case .immediate:
            return "Acting Busy Immediately"
        case .scheduled:
            return "Acting Busy at a Scheduled Time"
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}


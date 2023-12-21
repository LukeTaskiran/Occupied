import SwiftUI

struct ChatView: View {
    @State private var messages: [Message] = []
    @State private var userMessage: String = ""

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages, id: \.id) { message in
                        MessageView(message: message)
                    }
                }
                .padding()
            }

            HStack {
                TextField("Type a message...", text: $userMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: sendMessage) {
                    Text("Send")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding()
            .background(Color.secondary.opacity(0.2))
        }
        .navigationBarTitle("Chat with Bot", displayMode: .inline)
        .padding(.horizontal)
        .onAppear {
            // Initial bot greeting
            messages.append(Message(content: "Hello! How can I help you?", isUser: false))
        }
    }

    func sendMessage() {
        guard !userMessage.isEmpty else { return }

        // Add user's message
        messages.append(Message(content: userMessage, isUser: true))
        userMessage = "" // Clear the input field

        // Simulate bot response (you can replace this logic with an actual response from a chatbot)
        let botResponse = "I received your message!"
        messages.append(Message(content: botResponse, isUser: false))
    }
}

struct MessageView: View {
    var message: Message

    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                Text(message.content)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            } else {
                Text(message.content)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                Spacer()
            }
        }
    }
}

struct Message: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatView()
        }
    }
}

import SwiftUI
struct ChatWithAIView: View {
    @State private var chatMessage = ""
    @State private var chatHistory: [String] = []

    var body: some View {
        VStack {
            Text("Chat with AI")
                .font(.title)
                .foregroundColor(.blue)
                .padding()

            // Chat interface with AI
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(chatHistory, id: \.self) { message in
                        Text(message)
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)

            HStack {
                TextField("Type your message...", text: $chatMessage)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Send") {
                    chatHistory.append("You: \(chatMessage)")
                    // Implement logic to get AI response and add it to chatHistory
                    chatMessage = ""
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

// ContentView.swift

import SwiftUI

struct ContentView: View {
    @State private var selectedSetting: String?
    @State private var isShowingSelectedSetting = false

    var body: some View {
        @State var animateGradient = false
        NavigationView {
            ZStack{
                LinearGradient(colors: [.purple, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .hueRotation(.degrees(animateGradient ? 45 : 0))
                    .ignoresSafeArea()
                    .onAppear {
                        withAnimation(.easeInOut(duration: 5.0).repeatForever(autoreverses: true)) {
                            animateGradient.toggle()
                        }
                    }
                VStack {
                    HeaderView()
                        .padding(.bottom, 40)
                    
                    
                    // Setting selection buttons
                    SettingGridView(selectedSetting: $selectedSetting) {
                        self.isShowingSelectedSetting = true
                    }
                    .transition(.opacity)
                    
                    // Navigation link to the selected setting
                    NavigationLink(
                        destination: getSelectedSettingView(),
                        isActive: $isShowingSelectedSetting
                    ) {
                        EmptyView()
                    }
                    .hidden()
                }
                .padding(.horizontal, 20)
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)
            }
        }
    }

    // Determine the appropriate setting view based on the selectedSetting
    private func getSelectedSettingView() -> some View {
        if let selectedSetting = selectedSetting {
            switch selectedSetting {
            case "Office":
                return AnyView(OfficeSettingView())
            case "Party":
                return AnyView(PartySettingView())
            case "Friends":
                return AnyView(FriendsSettingView())
            /*case "Other":
                return AnyView(OtherSettingView())
            // Add similar cases for other settings...*/
            default:
                return AnyView(EmptyView())
            }
        } else {
            return AnyView(EmptyView())
        }
    }
}
struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.5 : 1)
            .animation(.easeOut(duration: 0.5), value: configuration.isPressed)
    }
}
struct SettingButtonView: View {
    var setting: String
    var action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            Text(setting)
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
        }
        .buttonStyle(GrowingButton())
    }
}

struct HeaderView: View {
    var body: some View {
        VStack {
            Text("BusyPulse")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(.top, 20)

            Text("Choose your setting")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(.top, 20)
        }
    }
}

struct SettingGridView: View {
    @Binding var selectedSetting: String?
    var onSettingSelected: () -> Void

    var body: some View {
        VStack(spacing: 30) {
            ForEach(["Office", "Party", "Friends"], id: \.self) { setting in
                SettingButtonView(setting: setting) {
                    self.selectedSetting = setting
                    onSettingSelected()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

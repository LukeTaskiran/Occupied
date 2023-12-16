// ContentView.swift

import SwiftUI

struct ContentView: View {
    @State private var selectedSetting: String?
    @State private var isShowingSelectedSetting = false

    var body: some View {
        NavigationView {
            VStack {
                HeaderView()

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
            case "Other":
                return AnyView(OtherSettingView())
            // Add similar cases for other settings...
            default:
                return AnyView(EmptyView())
            }
        } else {
            return AnyView(EmptyView())
        }
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
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}

struct HeaderView: View {
    var body: some View {
        VStack {
            Text("BusyPulse")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)

            Text("Choose your setting")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.top, 20)
        }
    }
}

struct SettingGridView: View {
    @Binding var selectedSetting: String?
    var onSettingSelected: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            ForEach(["Office", "Party", "Friends", "Other"], id: \.self) { setting in
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

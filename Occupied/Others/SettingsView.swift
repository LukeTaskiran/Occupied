import SwiftUI

struct SettingsView: View {
    @State private var isDarkModeEnabled: Bool = true
    @State private var downloadViaWifiEnabled: Bool = false
    @StateObject private var interstitialAdManager = InterstitialAdsView()

    @State private var languageIndex = 0
    var languageOptions = ["English", "Arabic", "Chinese", "Danish"]

    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack {
                        Image(uiImage: UIImage(named: "alli")!)
                            .resizable()
                            .frame(width: 100, height: 100, alignment: .center)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 10)
                        
                        Text("Joe Snow")
                            .font(.title)
                        Text("JoeSnow@busy.com")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text("Act busy and in the settings")
                            .font(.body)
                            .foregroundColor(.black)
                        
                        Button(action: {
                            print("Edit Profile tapped")
                            interstitialAdManager.displayInterstitialAd()
                        }) {
                            Text("Edit Profile")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .font(.system(size: 18))
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.white, lineWidth: 2)
                                    
                                )
                        }
                        .padding()
                        
                        SwiftUIBannerAd(adPosition: .bottom, adUnitId: "ca-app-pub-3940256099942544/2934735716")
                            .frame(height: 125,alignment: .center)
                            .padding()
                        
                        Divider()
                        
                        Section(header: Text("CONTENT").bold().foregroundColor(.blue)) {
                            SettingsRow(imageName: "Favourite", title: "Favorites").padding(30)
                            SettingsRow(imageName: "Download", title: "Downloads").padding(30)
                        }
                        
                        Section(header: Text("PREFERENCES").bold().foregroundColor(.blue)) {
                            SettingsPickerRow(imageName: "Language", title: "Language", options: languageOptions, selection: $languageIndex).padding(30)
                            SettingsToggleRow(imageName: "DarkMode", title: "Dark Mode", isOn: $isDarkModeEnabled).padding(30)
                            SettingsToggleRow(imageName: "DownloadViaWifi", title: "Only Download via Wi-Fi", isOn: $downloadViaWifiEnabled).padding(30)
                            SettingsRow(imageName: "PlayInBackground", title: "Play in Background").padding(30)
                        }
                    }
                    .padding()
                }.onAppear{
                    interstitialAdManager.loadInterstitialAd()
                }
                .disabled(!interstitialAdManager.interstitialAdLoaded)
            }
            .navigationBarTitle("Settings")
        }
    }
}

struct SettingsRow: View {
    var imageName: String
    var title: String

    var body: some View {
        HStack {
            Image(uiImage: UIImage(named: imageName)!)
            Text(title)
        }
    }
}

struct SettingsPickerRow: View {
    var imageName: String
    var title: String
    var options: [String]
    @Binding var selection: Int

    var body: some View {
        HStack {
            Image(uiImage: UIImage(named: imageName)!)
            Picker(selection: $selection, label: Text(title)) {
                ForEach(0 ..< options.count) {
                    Text(self.options[$0])
                }
            }
        }
    }
}

struct SettingsToggleRow: View {
    var imageName: String
    var title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Image(uiImage: UIImage(named: imageName)!)
            Toggle(isOn: $isOn) {
                Text(title)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

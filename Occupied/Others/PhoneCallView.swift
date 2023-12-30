import SwiftUI
import AVKit
struct PhoneCallView: View {
    @State private var isRinging = false
    @State private var showCallScreen = false
    @State private var showIncomingCall = false

    var body: some View {
            VStack {
                if showIncomingCall {
                    IncomingCallView(acceptAction: {
                        withAnimation {
                            showCallScreen = true
                            showIncomingCall = false
                        }
                    }, declineAction: {
                        withAnimation {
                            showIncomingCall = false
                        }
                    })
                } else if showCallScreen {
                    CallScreenView(endCallAction: {
                        withAnimation {
                            showCallScreen = false
                        }
                    })
                } else {
                    Button("Receive Call") {
                        withAnimation {
                            showIncomingCall = true
                        }
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    
                    SwiftUIBannerAd(adPosition: .bottom, adUnitId: "ca-app-pub-3940256099942544/2934735716")
                        .frame(height: 125,alignment: .center)
                        .offset(y:50)
                        .padding()
                }
            }

    }
}
struct CallScreenView: View {
    var endCallAction: () -> Void

    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            VStack {
                Spacer()
                
                Image(systemName: "phone.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                Text("Call in Progress")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Button("End Call") {
                    endCallAction()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(Capsule())
                
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct IncomingCallView: View {
    @State private var isRinging = false
    @State var audioPlayer: AVAudioPlayer!
    @State private var callDuration: Int = 0
    @State private var timer: Timer?
    
    var acceptAction: () -> Void
    var declineAction: () -> Void
    
    var body: some View {
        @State var animateGradient = false
        ZStack{
            LinearGradient(colors: [.gray, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                .hueRotation(.degrees(animateGradient ? 0 : 0))
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.easeInOut(duration: 5.0).repeatForever(autoreverses: true)) {
                        animateGradient.toggle()
                    }
                }
            VStack {
                Spacer(minLength: 30)
                
                Image(uiImage: UIImage(named: "person-icon")!)
                    .resizable()
                    .frame(width: 90, height: 105, alignment: .center)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .scaleEffect(isRinging ? 1.35 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)
                    )
                    .padding(.vertical, 20)
                    .onAppear {
                        if let soundPath = Bundle.main.path(forResource: "phone", ofType: "mp3") {
                            do {
                                self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath))
                            } catch {
                                // Handle the error, e.g., print an error message
                                print("Error creating AVAudioPlayer: \(error.localizedDescription)")
                            }
                        } else {
                            // Handle the case where the resource file is not found
                            print("Error: 'phone.mp3' not found in the main bundle.")
                        }
                        self.audioPlayer.play()

                        self.isRinging = true
                    }
                
                Text("Unknown Caller")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(.black)
                      
                
                HStack {
                    VStack{
                        
                        Button {
                            declineAction()
                        }label: {
                            VStack{
                                
                                Image(systemName: "alarm.fill")
                                    .resizable()
                                    .scaledToFit()
                                Text("Remind Me")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                
                            }
                            
                        }
                        .frame(height: 50, alignment: .center)
                        .padding()
                        .foregroundColor(.white)
                        
                        Button {
                            declineAction()
                        }label: {
                            Image(systemName: "phone.down.fill")
                                .resizable()
                                .scaledToFit()
                        }
                        .frame(width: 60, height: 60, alignment: .center)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        
                    }
                    Spacer(minLength: 40)
                    
                    VStack{
                        
                        Button {
                            declineAction()
                        }label: {
                            VStack{
                                                               
                                Image(systemName: "message.fill")
                                    .resizable()
                                    .scaledToFit()
                                Text("Message")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(height: 50, alignment: .center)
                        .padding()
                        .foregroundColor(.white)
                        Button{
                            acceptCall()
                        } label: {
                            Image(systemName: "phone.fill")
                                .resizable()
                                .scaledToFit()
                                .padding(.all,10)
                        }
                        .frame(width: 60, height: 60, alignment: .center)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                    }
                    
                }.frame(maxHeight: .infinity, alignment: .bottom)                .padding(.all,40)
                
                
                
                Spacer()
            }
            .onDisappear {
                // Invalidate the timer when the view disappears
                timer?.invalidate()
            }
            
        }
    }
    
    func acceptCall() {
        // Perform actions when the call is accepted
        acceptAction()
        
        // Start the timer when the call is accepted
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            callDuration += 1
            
            // Add additional logic based on the call duration if needed
        }
    }
}

struct PhoneCallView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PhoneCallView()
        }
    }
}

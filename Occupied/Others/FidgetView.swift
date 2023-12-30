import SwiftUI

struct CreativeFidgetView: View {
    @State private var rotation: Double = 0.0
    @State private var acceleration: Double = 0.0


    
    var body: some View {
        VStack {
            Text("Fidget Oasis")
                .font(.largeTitle)
                .padding()

            FidgetControlView(rotation: $rotation, acceleration: $acceleration)
                .padding(.bottom,90)

            
            FidgetSpinner(rotation: $rotation, acceleration: $acceleration)
                .frame(width: 80, height: 80)
                .scaleEffect(0.85)
                .padding(.bottom,60)
                

            Spacer(minLength: 30)
            
            HStack{
                Button("Press Me") {
                }
                .padding()
                .buttonStyle(GrowingButton1())
                
                Button("Advanced Button") {
                        }
                        .buttonStyle(CustomButtonStyle1())
            }.padding()
                    
            
        }
        .padding()
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(configuration.isPressed ? .pink : .orange)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.5 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
struct CustomButtonStyle1: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(configuration.isPressed ? .pink : .orange)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.5 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
struct GrowingButton1: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
struct FidgetControlView: View {
    @Binding var rotation: Double
    @Binding var acceleration: Double

    var body: some View {
        VStack {
            Text("Control the spinner")
                .font(.title)
                .padding()
            Slider(value: $rotation, in: 0...360, step: 1.0, label: { Text("Rotation") })
                .padding()

            Slider(value: $acceleration, in: 0...10, step: 0.1, label: { Text("Acceleration") })
                .padding()
        }
        .background(Color.gray.opacity(0.3))
        .cornerRadius(10)
        .padding()
    }
}

struct FidgetSpinner: View {
    @Binding var rotation: Double
    @Binding var acceleration: Double

    private let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.pink, .purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .mask(
                Image(systemName: "line.3.crossed.swirl.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .rotationEffect(.degrees(rotation))
            )
            .frame(width: 300, height: 300)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        acceleration += value.translation.height / 10
                    }
            )
            .foregroundColor(.pink)
            .onReceive(timer) { _ in
                acceleration += (acceleration * 0.0001)
                rotation += acceleration * 0.1
            }
        }
    }
}

struct CreativeFidgetView_Previews: PreviewProvider {
    static var previews: some View {
        CreativeFidgetView()
    }
}

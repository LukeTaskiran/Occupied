import SwiftUI

struct ImageMatchingView: View {
    @State private var correctAnimalIndex: Int = 0
    @State private var isMatched: Bool = false

    @State private var animalImages = [
        "alli", "dog", "Otter", "alli", "dog", "Otter","alli", "dog", "Otter","alli", "dog", "Otter","alli", "dog", "Otter","alli", "dog", "Otter","alli", "dog", "Otter","alli", "dog", "Otter","alli", "dog", "Otter","alli", "dog", "Otter","alli", "dog", "Otter","alli", "dog", "Otter","alli", "dog", "Otter","alli", "dog", "Otter","alli", "dog", "Otter","alli", "dog", "Otter","alli", "dog", "Otter","alli", "dog", "Otter",
    ]

    var body: some View {
        VStack {
            Text("Match the animal:")
                .font(.headline)
                .padding()

            Text(animalImages[correctAnimalIndex])
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Button(action: {
                shuffleAnimalImages()
            }) {
                Text("Shuffle Animals")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 10) {
                    ForEach(0..<animalImages.count, id: \.self) { index in
                        Button(action: {
                            checkIfMatched(selectedIndex: index)
                        }) {
                            Image(animalImages[index])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue, lineWidth: correctAnimalIndex == index ? 2 : 0)
                                )
                        }
                    }
                }
                .padding()
            }
        }
        .padding()
    }

    func shuffleAnimalImages() {
        animalImages.shuffle()
        correctAnimalIndex = Int.random(in: 0..<animalImages.count)
    }

    func checkIfMatched(selectedIndex: Int) {
        isMatched = correctAnimalIndex == selectedIndex

        // Generate a new correct animal for the next round
        correctAnimalIndex = Int.random(in: 0..<animalImages.count)
    }
}

struct ImageMatchingView_Previews: PreviewProvider {
    static var previews: some View {
        ImageMatchingView()
    }
}

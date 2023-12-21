// DrawingView.swift

import SwiftUI

import SwiftUI

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryMatchView(viewModel: MemoryMatchViewModel(difficulty: .easy, theme: .objects))
    }
}

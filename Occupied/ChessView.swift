import SwiftUI

struct ChessView: View {
    @State private var board: [[ChessPiece?]] = Array(repeating: Array(repeating: nil, count: 8), count: 8)
    @State private var selectedPiece: ChessPiece?
    @State private var turn: ChessPiece.Color = .white

    var body: some View {
        VStack {
            Text("Current Turn: \(turn.rawValue)")
                .padding()

            ForEach(0..<8, id: \.self) { row in
                HStack {
                    ForEach(0..<8, id: \.self) { col in
                        ChessSquare(piece: $board[row][col], onTap: { tappedSquare(row, col) })
                            .background(Color.gray.opacity((row + col).isMultiple(of: 2) ? 0.1 : 0.2))
                    }
                }
            }
        }
        .padding()
        .onAppear {
            initializeBoard()
        }
    }

    func initializeBoard() {
        // Set up initial pieces
        // For simplicity, this example only includes pawns
        for col in 0..<8 {
            board[1][col] = ChessPiece(color: .black, type: .pawn)
            board[6][col] = ChessPiece(color: .white, type: .pawn)
        }
    }

    func tappedSquare(_ row: Int, _ col: Int) {
        guard let piece = board[row][col] else {
            // If the square is empty, handle piece movement
            handleMove(row, col)
            return
        }

        // If the square has a piece, select it
        if piece.color == turn {
            selectedPiece = piece
        }
    }

    func handleMove(_ row: Int, _ col: Int) {
        guard let selectedPiece = selectedPiece else {
            return // No piece selected
        }

        // Check if the move is valid (implement your own logic here)
        let isValidMove = true // Replace with your move validation logic

        if isValidMove {
            board[row][col] = selectedPiece
            board[selectedPiece.row][selectedPiece.col] = nil
            selectedPiece.row = row
            selectedPiece.col = col
            turn = (turn == .white) ? .black : .white
        }

        // Clear selection
        self.selectedPiece = nil
    }
}

struct ChessSquare: View {
    @Binding var piece: ChessPiece?
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            piece?.getImage()
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding(5)
        }
    }
}

struct ChessPiece {
    enum Color: String {
        case white, black
    }

    enum `Type`: String {
        case pawn
        // Add other chess piece types as needed
    }

    let color: Color
    let type: Type
    var row: Int
    var col: Int

    func getImage() -> Image {
        let imageName = "\(color.rawValue)_\(type.rawValue)"
        return Image(imageName)
    }
}

struct ChessView_Previews: PreviewProvider {
    static var previews: some View {
        ChessView()
    }
}

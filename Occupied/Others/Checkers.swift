//

import SwiftUI

enum Piece: Int {
    case red
    case queenRed
    case black
    case queenBlack
}
enum winn{
    case red
    case blue
    case nonee
}


enum Background {
    case black
    case white
}

struct SquareView: View {
    let square: Square
    
    init(square: Square) {
        self.square = square
    }
    
    var body: some View {
        let backgroundColor: Color
        let pieceColor: Color?
        let isPromoted: Bool
        let squareBorder: Color
        
        switch square.background {
        case .black:
            backgroundColor = .black
        case .white:
            backgroundColor = .white
        }
        
        if let piece = square.piece {
            switch piece {
            case .black:
                pieceColor = .black
                isPromoted = false
            case .queenBlack:
                pieceColor = .black
                isPromoted = true
            case .red:
                pieceColor = .white
                isPromoted = false
            case .queenRed:
                pieceColor = .white
                isPromoted = true
            }
        } else {
            pieceColor = nil
            isPromoted = false
        }
        
        if square.selecting {
            squareBorder = .yellow
        } else {
            squareBorder = .clear
        }
        
        
        return ZStack {
            Rectangle()
                .foregroundColor(backgroundColor)
                .overlay(Rectangle().stroke(squareBorder, lineWidth: 2))
            if pieceColor != nil {
                Circle()
                    .foregroundColor(pieceColor!)
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .overlay(Circle().stroke(isPromoted ? Color.red : Color.clear, lineWidth: 5).padding(6))
                    .padding(4)
            }
        }
    }
}


struct Square: Identifiable {
    let id = UUID()
    
    let x: Int
    let y: Int
    let background: Background
    var piece: Piece?
    var selecting: Bool
    
    mutating func advancePiece() {
        switch piece {
        case .none:
            self.piece = Piece(rawValue: 0)
        case .some(let piece):
            self.piece = Piece(rawValue: piece.rawValue + 1)
        }
    }
}

struct Row: Identifiable {
    let id = UUID()
    var row: [Square]
    
    init(row: [Square]) {
        self.row = row
    }
}

struct Checker  {
    
    var board: [Row]
    var winner: winn?
    @State var black_p = 12
    @State var red_p = 12
    
    
    init() {
        winner = .nonee
        board = (0..<8).map { y in
            Row(row: (0..<8).map { x in
                if (x + y) % 2 == 0 {
                    return Square(x: x, y: y, background: .white, piece: nil, selecting: false)
                } else {
                    if y <= 2 {
                        return Square(x: x, y: y, background: .black, piece: .black, selecting: false)
                    } else if y <= 4 {
                        return Square(x: x, y: y, background: .black, piece: nil, selecting: false)
                    } else {
                        return Square(x: x, y: y, background: .black, piece: .red, selecting: false)
                    }
                }
            })
        }
    }
    
    
    
    func searchSelectingSquare() -> Square? {
        for y in 0..<8 {
            for x in 0..<8 {
                if board[y].row[x].selecting == true {
                    return board[y].row[x]
                }
            }
        }
        return nil
    }
    
    mutating func tapped(square: Square) {
        let beforeSelectingSquare = searchSelectingSquare()
        
        board[square.y].row[square.x].selecting = true
        
        if let beforeSelectingSquare = beforeSelectingSquare  {
            
            board[beforeSelectingSquare.y].row[beforeSelectingSquare.x].selecting = false
            let beforeSquare = board[beforeSelectingSquare.y].row[beforeSelectingSquare.x]
            let currentSquare = board[square.y].row[square.x]
            
            // TODO Confirm saure is black (Checkers piece must move on black)
            
            if beforeSquare.id == currentSquare.id {
                // If before position and current position is same, change piece type
                // board[beforeSelectingSquare.y].row[beforeSelectingSquare.x].advancePiece()
            } else if currentSquare.piece == nil && beforeSquare.piece != nil && currentSquare.background == .black && beforeSquare.background == .black
            {
                
                if beforeSelectingSquare.self.piece == .some(.red) || beforeSelectingSquare.self.piece == .some(.queenRed){
                    
                    if (currentSquare.x == beforeSquare.x + 1 || currentSquare.x == beforeSquare.x - 1
                    ) && currentSquare.y == beforeSquare.y-1{
                        
                        board[beforeSelectingSquare.y].row[beforeSelectingSquare.x].piece = nil
                        board[square.y].row[square.x].piece = beforeSquare.piece
                        
                        
                    }
                    //queen  move
                    else if ((currentSquare.x == beforeSquare.x + 1 || currentSquare.x == beforeSquare.x - 1
                    ) && (currentSquare.y == beforeSquare.y-1 || currentSquare.y == beforeSquare.y+1) && beforeSquare.self.piece == .some(.queenRed)){
                        board[beforeSelectingSquare.y].row[beforeSelectingSquare.x].piece = nil
                        board[square.y].row[square.x].piece = beforeSquare.piece
                    }
                    
                    
                    
                    else if beforeSelectingSquare.x >= 1 && beforeSelectingSquare.x <= 7 && beforeSelectingSquare.y >= 1{  // gerak merah && makan
                        if (board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x-1].self.piece == .some(.black) || board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x-1].self.piece == .some(.queenBlack)  || board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x+1].self.piece == .some(.black) || board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x+1].self.piece == .some(.queenBlack))     && currentSquare.piece == nil && currentSquare.y == beforeSquare.y-2 {
                            board[beforeSelectingSquare.y].row[beforeSelectingSquare.x].piece = nil
                            if currentSquare.x < beforeSquare.x {
                                board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x-1].piece = nil
                            }
                            else if currentSquare.x > beforeSquare.x {
                                board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x+1].piece = nil
                            }
                            
                            board[square.y].row[square.x].piece = beforeSquare.piece
                            black_p -= 1
                        }
                        //queen eat
                        else if (board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x-1].self.piece == .some(.black) || board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x-1].self.piece == .some(.queenBlack) || board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x+1].self.piece == .some(.black) ||
                                    board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x+1].self.piece == .some(.queenBlack) ||
                                    board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x-1].self.piece == .some(.black) || board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x-1].self.piece == .some(.queenBlack) || board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x+1].self.piece == .some(.black) || board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x+1].self.piece == .some(.queenBlack)
                        )     && currentSquare.piece == nil && (currentSquare.y == beforeSquare.y-2 || currentSquare.y == beforeSquare.y+2 ) && beforeSquare.self.piece == .some(.queenRed){
                            board[beforeSelectingSquare.y].row[beforeSelectingSquare.x].piece = nil
                            if currentSquare.x < beforeSquare.x && currentSquare.y < beforeSquare.y {
                                board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x-1].piece = nil
                            }
                            else if currentSquare.x > beforeSquare.x  && currentSquare.y < beforeSquare.y{
                                board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x+1].piece = nil
                            }
                            else if currentSquare.x < beforeSquare.x && currentSquare.y > beforeSquare.y {
                                board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x-1].piece = nil
                            }
                            else if currentSquare.x > beforeSquare.x && currentSquare.y > beforeSquare.y{
                                board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x+1].piece = nil
                            }
                            
                            board[square.y].row[square.x].piece = beforeSquare.piece
                            black_p -= 1
                        }
                        
                    }
                    else if beforeSelectingSquare.x < 1 {// gerak queen
                        if ( board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x+1].self.piece == .some(.black) || board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x+1].self.piece == .some(.queenBlack) || board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x+1].self.piece == .some(.black) ||
                                board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x+1].self.piece == .some(.queenBlack)) && currentSquare.piece == nil && (currentSquare.y == beforeSquare.y-2 || currentSquare.y == beforeSquare.y+2)  && beforeSquare.self.piece == .some(.queenRed){
                            board[beforeSelectingSquare.y].row[beforeSelectingSquare.x].piece = nil
                            if currentSquare.x > beforeSquare.x && currentSquare.y < beforeSquare.y {
                                board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x+1].piece = nil
                            }
                            else  if currentSquare.x > beforeSquare.x && currentSquare.y > beforeSquare.y {
                                board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x+1].piece = nil
                            }
                            
                            
                            
                            
                            
                            board[square.y].row[square.x].piece = beforeSquare.piece
                            black_p -= 1
                        }
                        else if ( board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x+1].self.piece == .some(.black) || board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x+1].self.piece == .some(.queenBlack)) && currentSquare.piece == nil && currentSquare.y == beforeSquare.y-2 {
                            board[beforeSelectingSquare.y].row[beforeSelectingSquare.x].piece = nil
                            if currentSquare.x > beforeSquare.x {
                                board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x+1].piece = nil
                            }
                            
                            
                            black_p -= 1
                            board[square.y].row[square.x].piece = beforeSquare.piece
                        }
                        
                        
                        
                    }
                    else if beforeSelectingSquare.y < 1 && beforeSquare.self.piece == .some(.queenRed){
                        if (board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x-1].self.piece == .some(.black) || board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x-1].self.piece == .some(.queenBlack) || board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x+1].self.piece == .some(.black) ||
                                board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x+1].self.piece == .some(.queenBlack)) && currentSquare.piece == nil && currentSquare.y == beforeSquare.y+2 {
                            board[beforeSelectingSquare.y].row[beforeSelectingSquare.x].piece = nil
                            if currentSquare.x < beforeSquare.x {
                                board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x-1].piece = nil
                            }
                            else if currentSquare.x > beforeSquare.x {
                                board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x+1].piece = nil
                            }
                            
                            board[square.y].row[square.x].piece = beforeSquare.piece
                            red_p -= 1
                        }
                        ///////////
                        
                    }
                    if currentSquare.y == 0 && beforeSquare.self.piece == .some(.red){
                        board[square.y].row[square.x].advancePiece()
                    }
                }
                else if beforeSquare.self.piece == .some(.black) || beforeSquare.self.piece == .some(.queenBlack){
                    if (currentSquare.x == beforeSquare.x + 1 || currentSquare.x == beforeSquare.x - 1
                    ) && currentSquare.y == beforeSquare.y+1{
                        board[beforeSelectingSquare.y].row[beforeSelectingSquare.x].piece = nil
                        board[square.y].row[square.x].piece = beforeSquare.piece
                        
                        
                    }
                    //queen  move
                    else if ((currentSquare.x == beforeSquare.x + 1 || currentSquare.x == beforeSquare.x - 1
                    ) && (currentSquare.y == beforeSquare.y-1 || currentSquare.y == beforeSquare.y+1) && beforeSquare.self.piece == .some(.queenBlack)){
                        board[beforeSelectingSquare.y].row[beforeSelectingSquare.x].piece = nil
                        board[square.y].row[square.x].piece = beforeSquare.piece
                    }
                    
                    else if beforeSelectingSquare.x >= 1 && beforeSelectingSquare.x <= 7 && beforeSelectingSquare.y >= 0 && beforeSelectingSquare.y < 7{ // gerak biru
                        if (board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x-1].self.piece == .some(.red) || board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x-1].self.piece == .some(.queenRed) || board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x+1].self.piece == .some(.red) || board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x+1].self.piece == .some(.queenRed)) && currentSquare.piece == nil && currentSquare.y == beforeSquare.y+2 {
                            board[beforeSelectingSquare.y].row[beforeSelectingSquare.x].piece = nil
                            if currentSquare.x < beforeSquare.x {
                                board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x-1].piece = nil
                            }
                            else if currentSquare.x > beforeSquare.x {
                                board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x+1].piece = nil
                            }
                            
                            board[square.y].row[square.x].piece = beforeSquare.piece
                            red_p -= 1
                        }
                        
                        //queen eat
                        else if (board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x-1].self.piece == .some(.red) || board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x-1].self.piece == .some(.queenRed) ||             board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x+1].self.piece == .some(.red) || board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x+1].self.piece == .some(.queenRed) ||
                                    board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x-1].self.piece == .some(.red) || board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x-1].self.piece == .some(.queenRed) || board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x+1].self.piece == .some(.red) || board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x+1].self.piece == .some(.queenRed)
                        )     && currentSquare.piece == nil && (currentSquare.y == beforeSquare.y-2 || currentSquare.y == beforeSquare.y+2 ) && beforeSquare.self.piece == .some(.queenBlack){
                            board[beforeSelectingSquare.y].row[beforeSelectingSquare.x].piece = nil
                            if currentSquare.x < beforeSquare.x && currentSquare.y < beforeSquare.y {
                                board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x-1].piece = nil
                            }
                            else if currentSquare.x > beforeSquare.x  && currentSquare.y < beforeSquare.y{
                                board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x+1].piece = nil
                            }
                            else if currentSquare.x < beforeSquare.x && currentSquare.y > beforeSquare.y {
                                board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x-1].piece = nil
                            }
                            else if currentSquare.x > beforeSquare.x && currentSquare.y > beforeSquare.y{
                                board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x+1].piece = nil
                            }
                            
                            board[square.y].row[square.x].piece = beforeSquare.piece
                            red_p -= 1
                        }
                        
                        
                        
                        
                    }
                    else if beforeSelectingSquare.x < 1{
                        //pinggir kNn
                        if ( board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x+1].self.piece == .some(.red) || board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x+1].self.piece == .some(.queenRed)  || board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x+1].self.piece == .some(.red) || board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x+1].self.piece == .some(.queenRed)) && currentSquare.piece == nil && (currentSquare.y == beforeSquare.y-2 || currentSquare.y == beforeSquare.y+2)  && beforeSquare.self.piece == .some(.queenBlack){
                            board[beforeSelectingSquare.y].row[beforeSelectingSquare.x].piece = nil
                            if currentSquare.x > beforeSquare.x && currentSquare.y < beforeSquare.y {
                                board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x+1].piece = nil
                            }
                            else  if currentSquare.x > beforeSquare.x && currentSquare.y > beforeSquare.y {
                                board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x+1].piece = nil
                            }
                            
                            
                            
                            red_p -= 1
                            
                            board[square.y].row[square.x].piece = beforeSquare.piece
                        }
                        else if ( board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x+1].self.piece == .some(.red) || board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x+1].self.piece == .some(.queenRed )) && currentSquare.piece == nil && currentSquare.y == beforeSquare.y+2 {
                            board[beforeSelectingSquare.y].row[beforeSelectingSquare.x].piece = nil
                            if currentSquare.x > beforeSquare.x {
                                board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x+1].piece = nil
                            }
                            
                            
                            ////......
                            red_p -= 1
                            board[square.y].row[square.x].piece = beforeSquare.piece
                        }
                        
                    }//...................................................................................................
                    else if beforeSelectingSquare.x > 6 && beforeSelectingSquare.self.piece == .some(.queenBlack){
                        if ( board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x-1].self.piece == .some(.red) || board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x-1].self.piece == .some(.queenRed) || board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x-1].self.piece == .some(.red) || board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x-1].self.piece == .some(.queenRed)) && currentSquare.piece == nil && currentSquare.y == beforeSquare.y-2 && beforeSquare.self.piece == .some(.queenBlack) {
                            board[beforeSelectingSquare.y].row[beforeSelectingSquare.x].piece = nil
                            if currentSquare.y < beforeSquare.y {
                                board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x-1].piece = nil
                            }
                            else if currentSquare.y>beforeSquare.y {
                                board[beforeSelectingSquare.y+1].row[beforeSelectingSquare.x-1].piece = nil
                            }
                            //..............................................................................
                            board[square.y].row[square.x].piece = beforeSquare.piece
                            red_p -= 1
                        }
                        
                    }
                    
                    else if beforeSelectingSquare.y > 6 && beforeSquare.self.piece == .some(.queenBlack){
                        if (board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x-1].self.piece == .some(.red) || board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x-1].self.piece == .some(.queenRed) || board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x+1].self.piece == .some(.red) || board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x+1].self.piece == .some(.queenRed)) && currentSquare.piece == nil && currentSquare.y == beforeSquare.y-2 {
                            board[beforeSelectingSquare.y].row[beforeSelectingSquare.x].piece = nil
                            if currentSquare.x < beforeSquare.x {
                                board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x-1].piece = nil
                            }
                            else if currentSquare.x > beforeSquare.x {
                                board[beforeSelectingSquare.y-1].row[beforeSelectingSquare.x+1].piece = nil
                            }
                            red_p -= 1
                            
                            board[square.y].row[square.x].piece = beforeSquare.piece
                        }
                    }
                    if currentSquare.y == 7 && beforeSquare.self.piece == .some(.black){
                        board[square.y].row[square.x].advancePiece()
                        
                    }
                }
                
                red_p -=  1
                print( red_p)
                
                // Move piece to (square.x, square.y)
                // If piece is already placed at this position, do nothing.
                
            }
            
            
            // TODO: Prohivit the move without Checkers rule
            // - must move diagonally forward before promoting
            // - after promoting, can move backward
            // - and the other! (Many rules exist)
            // TODO: Auto-Promote and Auto-Removal any pieces on rule of Checkers
        }
        
        var redd = 0
        var blue = 0
        for y in 0..<8 {
            for x in 0..<8 {
                if board[y].row[x].piece == .some(.queenRed) || board[y].row[x].piece == .some(.red) {
                    redd += 1
                    
                }
                if board[y].row[x].piece == .some(.queenBlack) || board[y].row[x].piece == .some(.black) {
                    blue += 1
                    
                }
            }
        }
        if redd == 0 {
            
            winner = .red
        }
        else if blue == 0 {
            winner = .blue
            
        }
        
        
    }
    
    mutating func longPressed(square: Square) {
        board[square.y].row[square.x].piece = nil
    }
    
}


struct Checkers : View {
    @State var checker = Checker()
    
    func NewGame(){
        checker.winner = .nonee
        checker.board = (0..<8).map { y in
            Row(row: (0..<8).map { x in
                if (x + y) % 2 == 0 {
                    return Square(x: x, y: y, background: .white, piece: nil, selecting: false)
                } else {
                    if y <= 2 {
                        return Square(x: x, y: y, background: .black, piece: .black, selecting: false)
                    } else if y <= 4 {
                        return Square(x: x, y: y, background: .black, piece: nil, selecting: false)
                    } else {
                        return Square(x: x, y: y, background: .black, piece: .red, selecting: false)
                    }
                }
            })
        }
    }
    
    
    
    
    var body: some View {
        
        ZStack{
           VStack(spacing: 0) {
                ForEach((0...7).reversed(), id: \.self) { y in
                    HStack(spacing: 0) {
                        ForEach(0...7, id: \.self) { x in
                            ((x + y).isMultiple(of: 2) ? Image("Black") : Image("white"))
                                .resizable()
                            //.frame(width: 48, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                    }
                }
            }
            
            
               
                
                
                VStack(spacing: 0) {
                    
                    ForEach(self.checker.board) { row in
                        HStack(spacing: 0) {
                            ForEach(row.row) { square in
                                SquareView(square: square)
                                    .onTapGesture {
                                        self.checker.tapped(square: square)
                                    }
                                    .onLongPressGesture {
                                        self.checker.longPressed(square: square)
                                    }
                                
                            }
                        }
                    }
                    
                    
                    //Button{
                 //       NewGame()
                        
                 //   } label: {
                 //       Text("Reset")
                 //   }
                    
                    
                    
                }
                .aspectRatio(1, contentMode: .fit)
                
        
            VStack{
                Spacer()
                    .frame(height: 50)
                    
                Image("download")
                     .resizable()
                    .frame(width:100, height: 100)
                
                
                Spacer()
                Spacer()
                Spacer()
                Image("restart")
                    .resizable()
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .frame(width:100, height: 100)
                    //.overlay(foregroundColor(.black))
                    .onTapGesture {
                        NewGame()
                    }
                    
                    
                
            }
            VStack{
            if checker.winner == .some(.red) {
                Image("Bwin")
                    .frame(width:300, height: 150)
                    .onTapGesture {
                        NewGame()
                    }
               
            }
            else if checker.winner == .some(.blue){
                Image("Wwin")
                    .frame(width:300, height: 150)
                    .onTapGesture {
                        NewGame()
                    }
            }
            }
            
        }
            }
            
        
    }



#if DEBUG
struct Checkers_Previews : PreviewProvider {
    static var previews: some View {
        Checkers()
    }
}
#endif


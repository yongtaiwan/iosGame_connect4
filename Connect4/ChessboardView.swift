//
//  ChessboardView.swift
//  Connect4
//
//  Created by FanRende on 2022/3/12.
//

import SwiftUI

struct ChessboardView: View {
    @ObservedObject var game: GameViewModel
    @State var chipOffsetY: Array<CGFloat> = Array(repeating: 0, count: Chessboard.BOARD.GRID.rawValue)

    var body: some View {
        let COL = Chessboard.BOARD.COL.rawValue
        let ROW = Chessboard.BOARD.ROW.rawValue
        let columns = Array(repeating: GridItem(spacing: 0), count: COL)

        return VStack {
            ArrowView(columns: columns, col: game.property.chessboard.targetColumn)
                .padding()

            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(0..<ROW) { i in
                    ForEach(0..<COL) { j in
                        let position = (ROW - i - 1) * COL + j
                        
                        switch(game.property.chessboard.content[position]) {
                        case .NONE:
                            GridView(.white.opacity(0), offset: chipOffsetY[position])
                            
                        case .PREVIEW_ONE:
                            GridView(.yellow.opacity(0.5), offset: chipOffsetY[position])
                            
                        case .PREVIEW_TWO:
                            GridView(.red.opacity(0.5), offset: chipOffsetY[position])

                        case .ONE:
                            GridView(.yellow, offset: chipOffsetY[position])
                            
                        case .TWO:
                            GridView(.red, offset: chipOffsetY[position])
                            
                        case .ONE_WIN:
                            GridView(.yellow, offset: chipOffsetY[position], toMark: true)
                            
                        case .TWO_WIN:
                            GridView(.red, offset: chipOffsetY[position], toMark: true)
                        }
                    }
                }
            }
            .overlay {
                BoardView(game: game, offset: $chipOffsetY)
            }
            .cornerRadius(20)
            .padding(.horizontal)
            .disabled(game.property.gameOver || game.property.waiting)
        }
    }
}

struct ChessboardView_Previews: PreviewProvider {
    static var previews: some View {
        ChessboardView(game: GameViewModel())
    }
}

struct ArrowView: View {
    let columns: Array<GridItem>
    let col: Int

    var body: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(columns.indices) { col in
                if col == self.col {
                    Image(systemName: "triangle.inset.filled")
                        .rotationEffect(Angle(degrees: 180))
                }
                else {
                    Image(systemName: "triangle.inset.filled")
                        .hidden()
                }
            }
        }
    }
}

struct GridView: View {
    let color: Color
    let offset: CGFloat
    let toMark: Bool
    
    init(_ color: Color, offset: CGFloat, toMark: Bool = false) {
        self.color = color
        self.offset = offset
        self.toMark = toMark
    }
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(color)
                .scaleEffect(0.65)
                .frame(height: 45)
                .offset(y: offset)

            if toMark {
                Circle()
                    .stroke(.green, lineWidth: 7)
                    .scaleEffect(0.55)
                    .overlay {
                        Circle()
                            .stroke(.gray, lineWidth: 3)
                            .scaleEffect(0.48)
                    }
            }
        }
    }
}

struct BoardView: View {
    @ObservedObject var game: GameViewModel
    @Binding var offset: Array<CGFloat>
    
    func oneTurn(col: Int = -1) -> Bool {
        if !game.property.gameOver && game.layDown(col: col) {
            game.property.waiting = true
            offset[game.property.chessboard.targetPosition] = -270

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(dampingFraction: 0.8)) {
                    offset[game.property.chessboard.targetPosition] = 0
                }
                game.judge()
                
                if game.property.type == .PVP || col != -1 || game.property.gameOver {
                    game.property.waiting = false
                }
            }

            return true
        }
        else {
            return false
        }
    }
    
    func dragGesture(col: Int, width: Double) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged({ value in
                let offset = Int(round(value.translation.width / width))
                let targetColumn = col + offset
                
                if targetColumn >= 0 && targetColumn < 7 {
                    game.property.chessboard.targetColumn = targetColumn
                    game.setPreview()
                }
            })
            .onEnded { value in
                if self.oneTurn() {
                    if game.property.type == .PVE && !game.property.gameOver {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.oneTurn(col: game.property.chessboard.validColumns.randomElement()!)
                        }
                    }
                }
            }
    }

    var body: some View {
        let COL = Chessboard.BOARD.COL.rawValue
        let ROW = Chessboard.BOARD.ROW.rawValue
        let columns = Array(repeating: GridItem(spacing: 0), count: COL)

        GeometryReader { geometry in
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(0..<ROW) { i in
                    ForEach(0..<COL) { j in
                        Color.blue
                            .frame(height: 45)
                            .mask(HoleShapeMask().fill(style: FillStyle(eoFill: true)))
                            .gesture(
                                dragGesture(col: j, width: Double(geometry.size.width) / Double(COL))
                            )
                    }
                }
            }
        }
    }
}

struct HoleShapeMask: Shape {
    func path(in rect: CGRect) -> Path {
        var shape = Rectangle().path(in: rect)
        shape.addPath(
            Circle()
                .path(in: CGRect(
                    x: rect.minX,
                    y: rect.midY / 2.65,
                    width: rect.width, height: rect.height*0.65
                ))
        )
        return shape
    }
}

//
//  ChessboardView.swift
//  Connect4
//
//  Created by FanRende on 2022/3/12.
//

import SwiftUI

struct ChessboardView: View {
    @ObservedObject var game: Game
    @State var chipOffsetY: Array<CGFloat> = Array(repeating: 0, count: Chessboard.BOARD.GRID.rawValue)

    var body: some View {
        let COL = Chessboard.BOARD.COL.rawValue
        let ROW = Chessboard.BOARD.ROW.rawValue
        let columns = Array(repeating: GridItem(spacing: 0), count: COL)

        return VStack {
            ArrowView(columns: columns, col: game.chessboard.targetColumn)
                .padding()

            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(0..<ROW) { i in
                    ForEach(0..<COL) { j in
                        let position = (ROW - i - 1) * COL + j
                        
                        switch(game.chessboard.content[position]) {
                        case Game.PLAYER.NONE:
                            GridView(.white.opacity(0), offset: chipOffsetY[position])
                            
                        case Game.PLAYER.ONE:
                            GridView(.yellow, offset: chipOffsetY[position])
                            
                        case Game.PLAYER.TWO:
                            GridView(.red, offset: chipOffsetY[position])
                            
                        case Game.PLAYER.ONE_WIN:
                            GridView(.yellow, offset: chipOffsetY[position], toMark: true)
                            
                        case Game.PLAYER.TWO_WIN:
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
            .disabled(game.gameOver)
        }
    }
}

struct ChessboardView_Previews: PreviewProvider {
    static var previews: some View {
        ChessboardView(game: Game())
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
    @ObservedObject var game: Game
    @Binding var offset: Array<CGFloat>
    
    func tapGesture(col: Int) -> some Gesture {
        TapGesture()
            .onEnded { _ in
                game.chessboard.targetColumn = col

                if game.layDown(col: col) {
                    offset[game.chessboard.targetPosition] = -270

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.spring(dampingFraction: 0.8)) {
                            offset[game.chessboard.targetPosition] = 0
                        }
                        game.judge()
                    }
                }
            }
    }
    
    func dragGesture(col: Int, width: Double) -> some Gesture {
        DragGesture()
            .onChanged({ value in
                let offset = Int(round(value.translation.width / width))
                game.chessboard.targetColumn = col + offset
            })
            .onEnded { value in
                if game.layDown(col: game.chessboard.targetColumn) {
                    offset[game.chessboard.targetPosition] = -270

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.spring(dampingFraction: 0.8)) {
                            offset[game.chessboard.targetPosition] = 0
                        }
                        game.judge()
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
                                SimultaneousGesture(
                                    tapGesture(col: j),
                                    dragGesture(col: j, width: Double(geometry.size.width) / Double(COL))
                            ))
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

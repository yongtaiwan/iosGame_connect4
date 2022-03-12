//
//  ChessboardView.swift
//  Connect4
//
//  Created by FanRende on 2022/3/12.
//

import SwiftUI

struct ChessboardView: View {
    @ObservedObject var game: Game
    @State var player: Game.PLAYER = .ONE
    @State var isLayingDown: Bool = false

    var body: some View {
        let columns = Array(repeating: GridItem(), count: Chessboard.COL)
        
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(0..<Chessboard.ROW) { i in
                ForEach(0..<Chessboard.COL) { j in
                    let position = (Chessboard.ROW - i - 1) * Chessboard.COL + j

                    Group {
                        switch(game.chessboard.content[position]) {
                        case Game.PLAYER.NONE:
                            Circle()
                                .foregroundColor(.white)
                        case Game.PLAYER.ONE:
                            if game.chessboard.targetPosition == position {
                                Circle()
                                    .foregroundColor(.yellow)
                            }
                            else {
                                Circle()
                                    .foregroundColor(.yellow)
                            }
                        case Game.PLAYER.TWO:
                            Circle()
                                .foregroundColor(.red)
                        }
                    }
                    .frame(width: 25, height: 25)
                    .padding(.vertical, 10)
                    .gesture(
                        TapGesture()
                            .onChanged { _ in
                                if game.layDown(col: j, player: player) {
                                    player = player == .ONE ? .TWO: .ONE
                                }
                            }
                            .onEnded { _ in
                                
                            }
                    )
                }
            }
        }
        .background(.blue)
        .cornerRadius(30)
        .padding()
    }
}

struct ChessboardView_Previews: PreviewProvider {
    static var previews: some View {
        ChessboardView(game: Game())
    }
}

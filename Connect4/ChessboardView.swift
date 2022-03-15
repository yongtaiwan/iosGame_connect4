//
//  ChessboardView.swift
//  Connect4
//
//  Created by FanRende on 2022/3/12.
//

import SwiftUI

struct ChessboardView: View {
    @ObservedObject var game: Game

    var body: some View {
        let COL = Chessboard.BOARD.COL.rawValue
        let ROW = Chessboard.BOARD.ROW.rawValue
        let columns = Array(repeating: GridItem(), count: COL)
        
        return LazyVGrid(columns: columns) {
            ForEach(0..<ROW) { i in
                ForEach(0..<COL) { j in
                    let position = (ROW - i - 1) * COL + j

                    Group {
                        switch(game.chessboard.content[position]) {
                        case Game.PLAYER.NONE:
                            Rectangle()
                                .overlay {
                                    Circle()
                                        .foregroundColor(.white)
                                        .scaleEffect(0.65)
                                }
                        case Game.PLAYER.ONE:
                            Rectangle()
                                .overlay {
                                    Circle()
                                        .foregroundColor(.yellow)
                                        .scaleEffect(0.65)
                                }
                        case Game.PLAYER.TWO:
                            Rectangle()
                                .overlay {
                                    Circle()
                                        .foregroundColor(.red)
                                        .scaleEffect(0.65)
                                }
                        case Game.PLAYER.ONE_WIN:
                            Rectangle()
                                .overlay {
                                    Circle()
                                        .foregroundColor(.yellow)
                                        .scaleEffect(0.65)
                                }
                                .overlay {
                                    Circle()
                                        .stroke(.green, lineWidth: 5)
                                        .scaleEffect(0.65)
                                }
                        case Game.PLAYER.TWO_WIN:
                            Rectangle()
                                .overlay {
                                    Circle()
                                        .foregroundColor(.red)
                                        .scaleEffect(0.65)
                                }
                                .overlay {
                                    Circle()
                                        .stroke(.green, lineWidth: 5)
                                        .scaleEffect(0.65)
                                }
                        }
                    }
                    .frame(width: 50, height: 45)
                    .foregroundColor(.white.opacity(0))
                    .onTapGesture {
                        if game.layDown(col: j) {
                            game.judge()
                        }
                    }
                }
            }
        }
        .background(.blue)
        .cornerRadius(30)
        .padding()
        .disabled(game.gameOver)
    }
}

struct ChessboardView_Previews: PreviewProvider {
    static var previews: some View {
        ChessboardView(game: Game())
    }
}

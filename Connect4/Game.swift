//
//  Chessboard.swift
//  Connect4
//
//  Created by FanRende on 2022/3/12.
//

import SwiftUI

struct Chessboard {
    static let COL = 7
    static let ROW = 6
    var content: Array<Game.PLAYER> = Array(repeating: Game.PLAYER.NONE, count: COL * ROW)
    var currentTops: Array<Int> = Array(repeating: 0, count: COL)
    var targetPosition: Int = -1
}

class Game: ObservableObject {
    @Published var chessboard = Chessboard()
    
    enum PLAYER {
        case NONE, ONE, TWO
    }
    
    func restart() {
        chessboard = Chessboard()
    }
    
    func layDown(col: Int, player: PLAYER) -> Bool {
        if chessboard.currentTops[col] >= Chessboard.ROW {
            return false
        }
        else {
            chessboard.targetPosition = chessboard.currentTops[col] * 7 + col
            chessboard.content[chessboard.targetPosition] = player
            chessboard.currentTops[col] += 1
            return true
        }
    }
}

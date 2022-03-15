//
//  Chessboard.swift
//  Connect4
//
//  Created by FanRende on 2022/3/12.
//

import SwiftUI

struct Chessboard {
    enum BOARD: Int {
        case COL = 7, ROW = 6, GRID = 42
    }
    var content: Array<Game.PLAYER> = Array(repeating: Game.PLAYER.NONE, count: BOARD.COL.rawValue * BOARD.ROW.rawValue)
    var currentTops: Array<Int> = Array(repeating: 0, count: BOARD.COL.rawValue)
    var targetPosition: Int = -1
    var startOfLine: Int = -1
}

class Game: ObservableObject {
    enum PLAYER {
        case NONE, ONE, TWO, ONE_WIN, TWO_WIN
    }
    enum DIRECTION: Int, CaseIterable {
        case SLASH = 6, VERTICAL = 7, BACKSLASH = 8, HORIZONTAL = 1
    }

    @Published var chessboard = Chessboard()
    @Published var thisTurn: PLAYER = .ONE
    @Published var remainSteps: Array<Int> = Array(repeating: Chessboard.BOARD.GRID.rawValue / 2, count: 2)
    @Published var gameOver: Bool = false
    @Published var judgement: PLAYER = .NONE
    
    func restart() {
        chessboard = Chessboard()
        thisTurn = .ONE
        remainSteps = Array(repeating: Chessboard.BOARD.GRID.rawValue / 2, count: 2)
        gameOver = false
        judgement = .NONE
    }
    
    func layDown(col: Int) -> Bool {
        if chessboard.currentTops[col] >= Chessboard.BOARD.ROW.rawValue {
            return false
        }
        else {
            chessboard.targetPosition = chessboard.currentTops[col] * 7 + col
            chessboard.content[chessboard.targetPosition] = thisTurn
            chessboard.currentTops[col] += 1
            
            switch(thisTurn) {
            case .ONE:
                thisTurn = .TWO
                remainSteps[0] -= 1
            case .TWO:
                thisTurn = .ONE
                remainSteps[1] -= 1
            default:
                break
            }
            return true
        }
    }
    
    func judge() {
        if remainSteps[0] == 0 && remainSteps[1] == 0 {
            judgement = .NONE
            gameOver = true
            return
        }
        
        func isValid(dir: DIRECTION, thisChip: Int, nextChip: Int) -> Bool {
            if nextChip < 0 || nextChip > Chessboard.BOARD.GRID.rawValue - 1 {
                return false
            }
            if dir != .VERTICAL
                && abs(thisChip % Chessboard.BOARD.COL.rawValue -
                       nextChip % Chessboard.BOARD.COL.rawValue) != 1 {
                return false
            }
            return true
        }
        
        let player: PLAYER = (thisTurn == .ONE) ? .TWO : .ONE
        
        for dir in DIRECTION.allCases {
            var thisChip = chessboard.targetPosition
            var nextChip = chessboard.targetPosition
            var count = 0
            chessboard.startOfLine = chessboard.targetPosition

            while count < 4 && chessboard.content[nextChip] == player {
                chessboard.startOfLine = nextChip
                count += 1
                thisChip = nextChip
                nextChip += dir.rawValue
                
                if !isValid(dir: dir, thisChip: thisChip, nextChip: nextChip) {
                    break
                }
            }

            nextChip = chessboard.targetPosition
            count -= 1

            while count < 4 && chessboard.content[nextChip] == player {
                count += 1
                thisChip = nextChip
                nextChip -= dir.rawValue
                
                if !isValid(dir: dir, thisChip: thisChip, nextChip: nextChip) {
                    break
                }
            }

            if count >= 4 {
                judgement = player
                gameOver = true

                for i in 0..<4 {
                    if player == .ONE {
                        chessboard.content[chessboard.startOfLine - i * dir.rawValue] = .ONE_WIN
                    }
                    else if player == .TWO {
                        chessboard.content[chessboard.startOfLine - i * dir.rawValue] = .TWO_WIN
                    }
                }

                return
            }
        }
    }
}

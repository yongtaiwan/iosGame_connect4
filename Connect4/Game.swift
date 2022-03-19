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
    var validColumns: Array<Int> = Array(0..<BOARD.COL.rawValue)
    var targetColumn: Int = 0
    var targetPosition: Int = 0
    var startOfLine: Int = 0
}

struct Game {
    enum TYPE: String, CaseIterable {
        case PVP = "person.fill", PVE = "display"
    }
    enum PLAYER {
        case NONE, PREVIEW_ONE, PREVIEW_TWO, ONE, TWO, ONE_WIN, TWO_WIN
    }
    enum DIRECTION: Int, CaseIterable {
        case SLASH = 6, VERTICAL = 7, BACKSLASH = 8, HORIZONTAL = 1
    }

    var type: TYPE = .PVP
    var chessboard = Chessboard()
    var thisTurn: PLAYER = .ONE
    var remainSteps: Array<Int> = Array(repeating: Chessboard.BOARD.GRID.rawValue / 2, count: 2)
    var waiting: Bool = false
    var gameOver: Bool = false
    var judgement: PLAYER = .NONE
    var score: Array<Int> = Array(repeating: 0, count: 3)
    var timer: Timer? = nil
    var timeUp: Bool = false
    var countDownTime: TimeInterval = 120
    var timerLabel = String()
    var formatter = DateFormatter()
    
    init() {
        self.formatter.dateFormat = "HH:mm:ss"
        let dateComponent = DateComponents(
            calendar: .current,
            hour: 0, minute: 2, second: 0)
        self.timerLabel =
            self.formatter.string(from: dateComponent.date!)
    }
}

class GameViewModel: ObservableObject {
    @Published var property = Game()

    func setType(type: Game.TYPE) {
        property.type = type
    }
    
    func countDown() {
        property.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            if self.property.countDownTime != 0 && !self.property.gameOver {
                self.property.countDownTime -= 1
                
                let dateComponent = DateComponents(
                    calendar: .current,
                    hour: 0,
                    minute: Int(self.property.countDownTime) / 60,
                    second: Int(self.property.countDownTime) % 60
                )
                self.property.timerLabel = self.property.formatter.string(from: dateComponent.date!)
            }
            else {
                self.property.timer?.invalidate()
                
                if self.property.countDownTime == 0 {
                    self.property.timeUp = true
                    self.property.gameOver = true
                    self.property.judgement = .NONE
                    self.property.score[1] += 1
                }
            }
        })
    }
    
    func restart() {
        property.chessboard = Chessboard()
        property.thisTurn = .ONE
        property.remainSteps = Array(repeating: Chessboard.BOARD.GRID.rawValue / 2, count: 2)
        property.gameOver = false
        property.judgement = .NONE
        property.timer?.invalidate()
        property.timeUp = false
        property.countDownTime = 120
        let dateComponent = DateComponents(calendar: .current, hour: 0, minute: 2, second: 0)
        property.timerLabel = property.formatter.string(from: dateComponent.date!)
        countDown()
    }
    
    func setPreview() {
        if property.chessboard.currentTops[property.chessboard.targetColumn] < Chessboard.BOARD.ROW.rawValue {
            if property.chessboard.content[property.chessboard.targetPosition] == .PREVIEW_ONE ||
                property.chessboard.content[property.chessboard.targetPosition] == .PREVIEW_TWO {
                property.chessboard.content[property.chessboard.targetPosition] = .NONE
            }

            property.chessboard.targetPosition =
                property.chessboard.currentTops[property.chessboard.targetColumn] * 7 + property.chessboard.targetColumn
            
            if property.thisTurn == .ONE {
                property.chessboard.content[property.chessboard.targetPosition] = .PREVIEW_ONE
            }
            else if property.thisTurn == .TWO {
                property.chessboard.content[property.chessboard.targetPosition] = .PREVIEW_TWO
            }
        }
    }
    
    func layDown(col: Int = -1) -> Bool {
        if col != -1 {
            property.chessboard.targetColumn = col
        }

        if !property.chessboard.validColumns.contains(property.chessboard.targetColumn) {
            return false
        }
        else {
            property.chessboard.targetPosition =
                property.chessboard.currentTops[property.chessboard.targetColumn] * 7 + property.chessboard.targetColumn
            property.chessboard.content[property.chessboard.targetPosition] = property.thisTurn
            property.chessboard.currentTops[property.chessboard.targetColumn] += 1

            if property.chessboard.currentTops[property.chessboard.targetColumn] >= Chessboard.BOARD.ROW.rawValue {
                property.chessboard.validColumns = property.chessboard.validColumns.filter {
                    $0 != property.chessboard.targetColumn
                }
            }
            
            switch(property.thisTurn) {
            case .ONE:
                property.thisTurn = .TWO
                property.remainSteps[0] -= 1
            case .TWO:
                property.thisTurn = .ONE
                property.remainSteps[1] -= 1
            default:
                break
            }
            return true
        }
    }
    
    func judge() {
        if property.remainSteps[0] == 0 && property.remainSteps[1] == 0 {
            property.judgement = .NONE
            property.gameOver = true
            property.score[1] += 1
            return
        }
        
        func isValid(dir: Game.DIRECTION, thisChip: Int, nextChip: Int) -> Bool {
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
        
        let player: Game.PLAYER = (property.thisTurn == .ONE) ? .TWO : .ONE
        
        for dir in Game.DIRECTION.allCases {
            var thisChip = property.chessboard.targetPosition
            var nextChip = property.chessboard.targetPosition
            var count = 0
            property.chessboard.startOfLine = property.chessboard.targetPosition

            while count < 4 && property.chessboard.content[nextChip] == player {
                property.chessboard.startOfLine = nextChip
                count += 1
                thisChip = nextChip
                nextChip += dir.rawValue
                
                if !isValid(dir: dir, thisChip: thisChip, nextChip: nextChip) {
                    break
                }
            }

            nextChip = property.chessboard.targetPosition
            count -= 1

            while count < 4 && property.chessboard.content[nextChip] == player {
                count += 1
                thisChip = nextChip
                nextChip -= dir.rawValue
                
                if !isValid(dir: dir, thisChip: thisChip, nextChip: nextChip) {
                    break
                }
            }

            if count >= 4 {
                property.judgement = player
                property.gameOver = true
                
                if property.judgement == .ONE {
                    property.score[0] += 1
                }
                else if property.judgement == .TWO {
                    property.score[2] += 1
                }

                for i in 0..<4 {
                    if player == .ONE {
                        property.chessboard.content[property.chessboard.startOfLine - i * dir.rawValue] = .ONE_WIN
                    }
                    else if player == .TWO {
                        property.chessboard.content[property.chessboard.startOfLine - i * dir.rawValue] = .TWO_WIN
                    }
                }

                return
            }
        }
    }
}

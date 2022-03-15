//
//  JudgeAlert.swift
//  Connect4
//
//  Created by FanRende on 2022/3/15.
//

import SwiftUI

struct JudgeAlert: View {
    @ObservedObject var game: Game

    var body: some View {
        Group {
            switch(game.judgement) {
            case .NONE:
                Text("平手")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
            case .ONE:
                Text("Player 1 勝利")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
            case .TWO:
                Text("Player 2 勝利")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
            default:
                Text("")
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding(30)
        .background(Color.secondary)
        .cornerRadius(30)
        .padding(30)
    }
}

struct JudgeAlert_Previews: PreviewProvider {
    static var previews: some View {
        JudgeAlert(game: Game())
    }
}

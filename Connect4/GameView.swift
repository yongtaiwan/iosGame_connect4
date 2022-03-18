//
//  GameView.swift
//  Connect4
//
//  Created by FanRende on 2022/3/12.
//

import SwiftUI

struct GameView: View {
    @Binding var isActive: Bool
    let type: Game.TYPE
    @StateObject var game: GameViewModel = GameViewModel()

    var body: some View {
        VStack {
            MenuBar(isActive: $isActive, game: game)
                .padding()

            Spacer()

            Scoreboard(game: game)
                .frame(height: 100)

            ChessboardView(game: game)

            Spacer()

            if game.property.gameOver {
                JudgeAlert(game: game)
            }
            else {
                JudgeAlert(game: game)
                    .hidden()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            self.game.setType(type: type)
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(isActive: .constant(true), type: Game.TYPE.PVP)
    }
}

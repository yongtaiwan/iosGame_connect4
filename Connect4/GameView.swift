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
    @Binding var setting: Setting
    @State var showSetting: Bool = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                MenuBar(isActive: $isActive, game: game, setting: $setting, showSetting: $showSetting)
                    .padding()

                Spacer()

                Scoreboard(game: game, setting: $setting)
                    .frame(height: 100)

                ChessboardView(game: game, setting: $setting)

                Spacer()

                if game.property.gameOver {
                    JudgeAlert(game: game, setting: $setting)
                }
                else {
                    JudgeAlert(game: game, setting: $setting)
                        .hidden()
                }
            }
            if showSetting {
                VStack {
                    MusicBlock(setting: $setting)
                }
                .background(Color("launchColor"))
                .cornerRadius(30)
                .padding()
                .padding([.top, .leading], 50)
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
        GameView(isActive: .constant(true), type: Game.TYPE.PVP, setting: .constant(Setting()))
    }
}

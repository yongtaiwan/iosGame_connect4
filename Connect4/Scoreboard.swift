//
//  Scoreboard.swift
//  Connect4
//
//  Created by FanRende on 2022/3/16.
//

import SwiftUI

struct Scoreboard: View {
    @ObservedObject var game: GameViewModel
    @Binding var setting: Setting
    
    var body: some View {
        VStack {
            HStack {
                Text("Player 1")
                    .font(.system(size: 14, design: .monospaced))
                Spacer()
                Text("Player Turn")
                    .font(.system(size: 14, design: .monospaced))
                Spacer()
                Text((game.property.type == .PVP) ? "Player 2": "Environment")
                    .font(.system(size: 14, design: .monospaced))
            }
            .padding(.horizontal)
    
            Divider()
            HStack(alignment: .top) {
                Circle()
                    .foregroundColor(setting.playerColor[0])
                    .frame(width: 50, height: 50)
                    .padding(.leading)
                    .overlay {
                        Text("\(game.property.remainSteps[0])")
                            .font(.system(size: 24, design: .monospaced))
                            .fontWeight(.heavy)
                            .offset(x: 40, y: 40)
                    }
                
                Spacer()
                Divider()
                
                VStack {
                    if game.property.thisTurn == .ONE {
                        Circle()
                            .foregroundColor(setting.playerColor[0])
                            .frame(width: 30, height: 30)
                    }
                    else if game.property.thisTurn == .TWO {
                        Circle()
                            .foregroundColor(setting.playerColor[1])
                            .frame(width: 30, height: 30)
                    }
                    
                    Text("🕘 \(game.property.timerLabel)")
                        .font(.system(size: 18, design: .monospaced))
                        .fontWeight(.heavy)
                        .padding(.horizontal, 30)
                    Text("🏁  \(game.property.score[0]): \(game.property.score[1]): \(game.property.score[2])")
                        .font(.system(size: 18, design: .monospaced))
                        .fontWeight(.heavy)
                        .padding(.horizontal, 30)
                }

                Divider()
                Spacer()
                
                Circle()
                    .foregroundColor(setting.playerColor[1])
                    .frame(width: 50, height: 50)
                    .padding(.trailing)
                    .overlay {
                        Text("\(game.property.remainSteps[1])")
                            .font(.system(size: 24, design: .monospaced))
                            .fontWeight(.heavy)
                            .offset(x: -40, y: 40)
                    }
            }
            Divider()
        }
    }
}

struct Scoreboard_Previews: PreviewProvider {
    static var previews: some View {
        Scoreboard(game: GameViewModel(), setting: .constant(Setting()))
    }
}

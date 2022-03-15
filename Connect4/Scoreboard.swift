//
//  Scoreboard.swift
//  Connect4
//
//  Created by FanRende on 2022/3/16.
//

import SwiftUI

struct Scoreboard: View {
    @ObservedObject var game: Game
    
    var body: some View {
        VStack {
            HStack {
                Text("Player 1")
                Spacer()
                Text("Player Turn")
                Spacer()
                Text("Player 2")
            }
            .padding(.horizontal)
    
            Divider()
            HStack {
                VStack {
                    Circle()
                        .foregroundColor(.yellow)
                        .frame(width: 30, height: 30)
                        .offset(x: -50)
                    Text("\(game.remainSteps[0])")
                        .font(.title)
                        .fontWeight(.heavy)
                }
                
                Divider()
                
                VStack {
                    if game.thisTurn == .ONE {
                        Circle()
                            .foregroundColor(.yellow)
                            .frame(width: 30, height: 30)
                    }
                    else if game.thisTurn == .TWO {
                        Circle()
                            .foregroundColor(.red)
                            .frame(width: 30, height: 30)
                    }

                    Text("\(game.score[0]):\(game.score[1]):\(game.score[2])")
                        .font(.title)
                        .fontWeight(.heavy)
                        .padding(.horizontal, 30)
                }

                Divider()
                
                VStack {
                    Circle()
                        .foregroundColor(.red)
                        .frame(width: 30, height: 30)
                        .offset(x: 50)
                    Text("\(game.remainSteps[1])")
                        .font(.title)
                        .fontWeight(.heavy)
                }
            }
            Divider()
        }
    }
}

struct Scoreboard_Previews: PreviewProvider {
    static var previews: some View {
        Scoreboard(game: Game())
    }
}

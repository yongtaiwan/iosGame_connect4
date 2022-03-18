//
//  Scoreboard.swift
//  Connect4
//
//  Created by FanRende on 2022/3/16.
//

import SwiftUI

struct Scoreboard: View {
    @ObservedObject var game: GameViewModel
    
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
                    Text("\(game.property.remainSteps[0])")
                        .font(.title)
                        .fontWeight(.heavy)
                }
                
                Divider()
                
                VStack {
                    if game.property.thisTurn == .ONE {
                        Circle()
                            .foregroundColor(.yellow)
                            .frame(width: 30, height: 30)
                    }
                    else if game.property.thisTurn == .TWO {
                        Circle()
                            .foregroundColor(.red)
                            .frame(width: 30, height: 30)
                    }

                    Text("\(game.property.score[0]):\(game.property.score[1]):\(game.property.score[2])")
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
                    Text("\(game.property.remainSteps[1])")
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
        Scoreboard(game: GameViewModel())
    }
}

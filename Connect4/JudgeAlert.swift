//
//  JudgeAlert.swift
//  Connect4
//
//  Created by FanRende on 2022/3/15.
//

import SwiftUI

struct JudgeAlert: View {
    @ObservedObject var game: GameViewModel
    @State private var offset: CGFloat = 200
    @Binding var setting: Setting

    var body: some View {
        
        Button {
            game.restart()
        } label: {
            VStack {
                Group {
                    switch(game.property.judgement) {
                    case .NONE:
                        Text("🏳️ Tie Game 🏴")
                            .font(.title)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                    case .ONE:
                        Text("🎉 Player 1 Wins 🎉")
                            .font(.title)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                    case .TWO:
                        Text("🎉 Player 2 Wins 🎉")
                            .font(.title)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                    default:
                        Text("")
                    }
                }
                .padding()
                .background(LinearGradient(colors: [setting.playerColor[0], setting.playerColor[1]], startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(20)

                Label("Next Round", systemImage: "forward.fill")
                    .font(.subheadline)
                
            }
        }
        .padding(.bottom)
        .offset(y: offset)
        .animation(.easeIn(duration: 0.5), value: offset)
        .onAppear {
            self.offset = 0
        }
    }
}

struct JudgeAlert_Previews: PreviewProvider {
    static var previews: some View {
        JudgeAlert(game: GameViewModel(), setting: .constant(Setting()))
    }
}

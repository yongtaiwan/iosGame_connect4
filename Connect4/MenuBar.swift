//
//  MenuBar.swift
//  Connect4
//
//  Created by FanRende on 2022/3/12.
//

import SwiftUI

struct MenuBar: View {
    @Binding var isActive: Bool
    @ObservedObject var game: GameViewModel
    @Binding var setting: Setting
    @Binding var showSetting: Bool

    var body: some View {
        HStack {
            Spacer()
            Group {
                Button {
                    showSetting.toggle()
                } label: {
                    Image(systemName: "speaker.wave.2")
                        .resizable()
                        .scaledToFit()
                }
                Button {
                    game.restart()
                } label: {
                    Image(systemName: "gobackward")
                        .resizable()
                        .scaledToFit()
                }
                Button {
                    isActive = false
                } label: {
                    Image(systemName: "house")
                        .resizable()
                        .scaledToFit()
                }
            }
            .foregroundColor(.white)
            .frame(width: 25, height: 25)
            .padding(10)
            .background(.blue)
            .clipShape(Circle())
        }
    }
}

struct MenuBar_Previews: PreviewProvider {
    static var previews: some View {
        MenuBar(isActive: .constant(true), game: GameViewModel(), setting: .constant(Setting()), showSetting: .constant(false))
    }
}

//
//  PVPView.swift
//  Connect4
//
//  Created by FanRende on 2022/3/12.
//

import SwiftUI

struct PVPView: View {
    @Binding var isActive: Bool
    @StateObject var game = Game()

    var body: some View {
        VStack {
            MenuBar(isActive: $isActive, game: game)
                .padding()

            Spacer()

            ChessboardView(game: game)

            Spacer()
        }
        .navigationBarHidden(true)
    }
}

struct PVPView_Previews: PreviewProvider {
    static var previews: some View {
        PVPView(isActive: .constant(true))
    }
}

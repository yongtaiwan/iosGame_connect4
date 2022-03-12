//
//  ContentView.swift
//  Connect4
//
//  Created by FanRende on 2022/3/12.
//

import SwiftUI

struct ContentView: View {
    @State var startPVP: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Connect4")
                    .font(.largeTitle)
                    .foregroundColor(.blue)

                Spacer()
                
                NavigationLink(isActive: $startPVP) {
                    PVPView(isActive: $startPVP)
                } label: {
                    Text("START GAME!")
                        .font(.largeTitle)
                        .foregroundColor(.yellow)
                        .padding()
                        .background(.blue)
                        .cornerRadius(20)
                }
                .padding(.bottom, 100)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

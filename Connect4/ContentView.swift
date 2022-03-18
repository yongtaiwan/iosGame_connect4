//
//  ContentView.swift
//  Connect4
//
//  Created by FanRende on 2022/3/12.
//

import SwiftUI

struct ContentView: View {
    @State var start: Bool = false
    @State var type: Game.TYPE = .PVP

    var body: some View {
        NavigationView {
            VStack {
                Text("Connect4")
                    .font(.custom("Chalkboard", size: 72))
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .overlay {
                        Decoration()
                    }

                Spacer()
                
                OptionView(option: $type)

                Spacer()

                NavigationLink(isActive: $start) {
                    GameView(isActive: $start, type: type)
                } label: {
                    Text("START GAME!")
                        .font(.custom("Chalkboard", size: 38))
                        .fontWeight(.bold)
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

struct OptionView: View {
    @Binding var option: Game.TYPE

    var body: some View {
        VStack {
            ForEach(Game.TYPE.allCases, id: \.self) { type in
                HStack {
                    Group {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                        Text("\tv.s.\t")
                            .font(.title)
                            .fontWeight(.bold)
                        Image(systemName: type.rawValue)
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(height: 30)
                }
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .padding()
                .overlay {
                    if type == option {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.yellow)
                    }
                }
                .onTapGesture {
                    option = type
                }
            }
        }
    }
}

struct Decoration: View {
    func Chip(_ color: Color, x: CGFloat, y: CGFloat) -> some View {
        Circle()
            .fill(color)
            .frame(width: 30)
            .offset(x: x, y: y)
    }
    var body: some View {
        ZStack {
            Chip(.yellow, x: -160, y: -30)
            Chip(.red, x: -80, y: 40)
            Chip(.red, x: 120, y: -70)
            Chip(.yellow, x: 40, y: 60)
        }
    }
}

//
//  SettingView.swift
//  Connect4
//
//  Created by FanRende on 2022/3/18.
//

import SwiftUI
import AVKit

struct Setting {
    var playerColor: Array<Color> = [.yellow, .red]
    var music: String = "The_Bluest_Star"
    var soundEffect: String = "putting_a_pencil"
    var musicVolume: Float = 1
    var soundEffectVolume: Float = 1
    var player = AVQueuePlayer()
    var looper: AVPlayerLooper
    var player2: AVPlayer
    
    init() {
        let item = AVPlayerItem(url: Bundle.main.url(forResource: self.music, withExtension: "mp3")!)
        self.looper = AVPlayerLooper(player: self.player, templateItem: item)
        self.player.volume = self.musicVolume
        self.player.play()
        
        self.player2 = AVPlayer(url: Bundle.main.url(forResource: self.soundEffect, withExtension: "mp3")!)
        self.player2.volume = self.soundEffectVolume
    }
}

struct SettingView: View {
    @Binding var show: Bool
    @Binding var setting: Setting

    var body: some View {
        VStack(alignment: .leading){
            Button {
                show = false
            } label: {
                Image(systemName: "multiply")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
            }
            .padding()

            List {
                Section {
                    ColorBlock(setting: $setting)
                        .listRowBackground(Color("launchColor"))
                } header: {
                    Text("Color")
                }
                Section {
                    MusicBlock(setting: $setting)
                        .listRowBackground(Color("launchColor"))
                } header: {
                    Text("Music")
                }
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(show: .constant(true), setting: .constant(Setting()))
    }
}

struct ColorBlock: View {
    @Binding var setting: Setting
    
    var body: some View {
        Group {
            ColorPicker("Player 1", selection: $setting.playerColor[0])
            ColorPicker("Player 2", selection: $setting.playerColor[1])
        }
        .font(.system(size: 18, design: .monospaced))
        .padding()
    }
}

struct MusicBlock: View {
    @Binding var setting: Setting
    
    var body: some View {
        Group {
            HStack {
                Text("Background\t\t")
                    .font(.system(size: 18, design: .monospaced))
                Slider(value: $setting.musicVolume,
                       in: 0...5,
                       step: 0.1
                ) {}
                    .onChange(of: setting.musicVolume) { newValue in
                        setting.player.volume = newValue
                    }
            }
            HStack {
                Text("Sound Effect\t")
                    .font(.system(size: 18, design: .monospaced))
                Slider(value: $setting.soundEffectVolume,
                       in: 0...5,
                       step: 0.1
                ) {}
                    .onChange(of: setting.soundEffectVolume) { newValue in
                        setting.player2.volume = newValue
                    }
            }
        }
        .padding()
    }
}

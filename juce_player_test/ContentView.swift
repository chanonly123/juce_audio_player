//
//  ContentView.swift
//  juce_player_test
//
//  Created by Chandan on 27/09/24.
//

import SwiftUI
import AVKit

func swiftListener(arg1: UnsafePointer<CChar>, arg2: UnsafePointer<CChar>, value: Float) {
    let str1 = String(cString: arg1)
    let str2 = String(cString: arg2)
    print("Swift Listener called with: \(str1), \(str2), \(value)")
}

struct ContentView: View {

    @State var player = JuceMixPlayer_init()
    @State var item = JuceMixItem_init()

    var body: some View {
        VStack(spacing: 24) {
            Button("Open file") {
                let path = Bundle.main.path(forResource: "music", ofType: "wav")!
                JuceMixItem_setPath(item, path.cString(using: .utf8), 0, 0)
                JuceMixPlayer_addItem(player, item)
            }

            Button("Set Listener") {
//                var listener: (UnsafePointer<CChar>, UnsafePointer<CChar>, Float) -> Void = swiftListener
//                let addr = UInt(bitPattern: UnsafeRawPointer(&listener))
//                native_call(player, "setListener", ["listener": addr].toJsonString)
            }

            Button("play") {
                JuceMixPlayer_play(player)
            }

            Button("Pause") {
                JuceMixPlayer_pause(player)
            }

            Button("Stop") {
//                native_call(player, "stop", nil)
            }

            Button("Destroy") {
//                native_call(player, "destroy", nil)
//                native_call(item, "destroy", nil)
            }
        }
        .padding()
        .onAppear {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
                try AVAudioSession.sharedInstance().setActive(true)
            } catch let err {
                print("\(err)")
            }
        }
    }
}

#Preview {
    ContentView()
}
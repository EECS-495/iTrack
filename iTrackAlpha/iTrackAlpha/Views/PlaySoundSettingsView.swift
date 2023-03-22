//
//  PlaySoundSettingsView.swift
//  iTrackAlpha
//
//  Created by Danielle Maraffino on 3/22/23.
//

import SwiftUI
import AVFoundation

struct PlaySoundSettingsView: View {
    @Binding var playSound: Bool
    @Binding var selectState: selectedState
    @Binding var showSoundTut: Bool
    @State var audioPlayer: AVAudioPlayer!
    
    var body: some View {
        HStack{
            Text("Play Sound on Action")
                .foregroundColor(.black)
                .padding([.leading, .trailing])
            Spacer()
            Toggle(isOn: $playSound, label: {Text("")})
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .frame(width: 60, height: 50)
                .border(.blue, width: addBorder(buttonId: 2))
                .padding([.leading, .trailing])
            Button(action: {tutorial(buttonId: 2)}) {
                Text("?")
                    .foregroundColor(isTutorialSelected(buttonId: 2) ? .blue : .black)
                    .overlay(
                        Circle()
                            .stroke(isTutorialSelected(buttonId: 2) ? .blue : .black)
                            .frame(width: 20, height: 20)
                    )
            }
            .padding([.trailing])
            .scaleEffect(isTutorialSelected(buttonId: 2) ? 1.4 : 1.0)

        }
        .onChange(of: playSound) { _ in
            if playSound {
                playSound = true
            } else {
                playSound = false
            }
        }
        if showSoundTut {
            Text("Enabling this will cause a sound to play when a blink or action that changes the contents of the screen is registered")
                .foregroundColor(.blue)
                .padding([.leading, .trailing])
        }
    }
    private func tutorial(buttonId: Int) {
        // set bools based on the clicked button
        // turn on and off by blink clicking
        if showSoundTut {
            showSoundTut = false
        } else {
            showSoundTut = true
        }
    }
    
    private func isTutorialSelected(buttonId: Int) -> Bool{
        if selectState.buttonType == ButtonType.settingTutorial {
            if buttonId == selectState.buttonId {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    private func makeSound() {
        guard let soundURL = Bundle.main.url(forResource: "blinkTone.wav", withExtension: nil) else {
                    fatalError("Unable to find blinkTone.wav in bundle")
            }

            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            } catch {
                print(error.localizedDescription)
            }
            audioPlayer.play()
    }
    
    private func addBorder(buttonId: Int) -> CGFloat {
        if selectState.buttonType == ButtonType.settingToggle && buttonId == selectState.buttonId {
            return 3.0
        } else {
            return 0
        }
    }
}

struct PlaySoundSettingsView_Previews: PreviewProvider {
    static private var tempSelect = selectedState(buttonType: ButtonType.settingToggle, buttonId: 0, clickState: 0, isNo: false )
    
    static var previews: some View {
        PlaySoundSettingsView(playSound: .constant(true), selectState: .constant(tempSelect), showSoundTut: .constant(false))
    }
}

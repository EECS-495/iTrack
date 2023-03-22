//
//  ExtendBlinkSettingsView.swift
//  iTrackAlpha
//
//  Created by Danielle Maraffino on 3/22/23.
//

import SwiftUI
import AVFoundation

struct ExtendBlinkSettingsView: View {
    @Binding var longerBlinkDelay: Bool
    @Binding var selectState: selectedState
    @Binding var showBlinkDelayTut: Bool
    @State var audioPlayer: AVAudioPlayer!

    var body: some View {
        HStack{
            Text("Extend Blink Delay")
                .foregroundColor(.black)
                .padding([.trailing, .leading])
            Spacer()
            Toggle(isOn: $longerBlinkDelay, label: {Text("")})
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .frame(width: 60, height: 50)
                .border(.blue, width: addBorder(buttonId: 0))
                .padding([.leading, .trailing])
            Button(action: {tutorial(buttonId: 0)}) {
                Text("?")
                    .foregroundColor(isTutorialSelected(buttonId: 0) ? .blue : .black)
                    .overlay(
                        Circle()
                            .stroke(isTutorialSelected(buttonId: 0) ? Color.blue : Color.black)
                            .frame(width: 20, height: 20)
                    )
            }
            .padding([.trailing])
            .scaleEffect(isTutorialSelected(buttonId: 0) ? 1.4 : 1.0)


        }
        .onChange(of: longerBlinkDelay) { _ in
            if longerBlinkDelay {
                longerBlinkDelay = true
            } else {
                longerBlinkDelay = false
            }
        }
        if showBlinkDelayTut {
            Text("Extending the blink delay will increase the amount of time a user's eyes will need to be closed for a blink to be registered")
                .foregroundColor(.blue)
                .padding([.leading, .trailing])
        }
    }
    
    private func tutorial(buttonId: Int) {
        // set bools based on the clicked button
        // turn on and off by blink clicking
        if showBlinkDelayTut {
            showBlinkDelayTut = false
        } else {
            showBlinkDelayTut = true
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
    
    private func changeBlink(isLarge: Bool) {
        if isLarge {
            longerBlinkDelay = true
        } else {
            longerBlinkDelay = false
        }
    }
    
    private func addBorder(buttonId: Int) -> CGFloat {
        if selectState.buttonType == ButtonType.settingToggle && buttonId == selectState.buttonId {
            return 3.0
        } else {
            return 0
        }
    }
}

struct ExtendBlinkSettingsView_Previews: PreviewProvider {
    static private var tempSelect = selectedState(buttonType: ButtonType.settingToggle, buttonId: 0, clickState: 0, isNo: false )
    static var previews: some View {
        ExtendBlinkSettingsView(longerBlinkDelay: .constant(false), selectState: .constant(tempSelect), showBlinkDelayTut: .constant(false))
    }
}

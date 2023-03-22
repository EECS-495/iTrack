//
//  ExtendGazeSettingsView.swift
//  iTrackAlpha
//
//  Created by Danielle Maraffino on 3/22/23.
//

import SwiftUI
import AVFoundation

struct ExtendGazeSettingsView: View {
    @Binding var longerGazeDelay: Bool
    @Binding var selectState: selectedState
    @Binding var showGazeDelayTut: Bool
    @State var audioPlayer: AVAudioPlayer!
    
    var body: some View {
        HStack{
            Text("Extend Gaze Delay")
                .foregroundColor(.black)
                .padding([.trailing, .leading])
            Spacer()
            Toggle(isOn: $longerGazeDelay, label: {Text("")})
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .frame(width: 60, height: 50)
                .border(.blue, width: addBorder(buttonId: 1))
                .padding([.leading, .trailing])
            Button(action: {tutorial(buttonId: 1)}) {
                Text("?")
                    .foregroundColor(isTutorialSelected(buttonId: 1) ? .blue : .black)
                    .overlay(
                        Circle()
                            .stroke(isTutorialSelected(buttonId: 1) ? .blue : .black)
                            .frame(width: 20, height: 20)
                    )
            }
            .padding([.trailing])
            .scaleEffect(isTutorialSelected(buttonId: 1) ? 1.4 : 1.0)

        }
        .onChange(of: longerGazeDelay) { _ in
            if longerGazeDelay {
                longerGazeDelay = true
            } else {
                longerGazeDelay = false
            }
        }
        if showGazeDelayTut {
            Text("Extending the gaze delay will increase the amount of time a user's eyes will need to look in a direction for a change in gaze direction to be registered")
                .foregroundColor(.blue)
                .padding([.leading, .trailing])
        }
    }
    private func tutorial(buttonId: Int) {
        // set bools based on the clicked button
        // turn on and off by blink clicking
        if showGazeDelayTut {
            showGazeDelayTut = false
        } else {
            showGazeDelayTut = true
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

struct ExtendGazeSettingsView_Previews: PreviewProvider {
    static private var tempSelect = selectedState(buttonType: ButtonType.settingToggle, buttonId: 0, clickState: 0, isNo: false )
    
    static var previews: some View {
        ExtendGazeSettingsView(longerGazeDelay: .constant(false), selectState: .constant(tempSelect), showGazeDelayTut: .constant(false))
    }
}

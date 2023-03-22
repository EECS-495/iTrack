//
//  ShowConfirmSettingsView.swift
//  iTrackAlpha
//
//  Created by Danielle Maraffino on 3/22/23.
//

import SwiftUI
import AVFoundation

struct ShowConfirmSettingsView: View {
    @Binding var showConfirmationScreen: Bool
    @Binding var selectState: selectedState
    @Binding var showConfirmationTut: Bool
    @State var audioPlayer: AVAudioPlayer!
    
    var body: some View {
        HStack{
            Text("Show Confirmation Screen")
                .foregroundColor(.black)
                .padding([.leading, .trailing])
            Spacer()
            Toggle("", isOn: $showConfirmationScreen)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .frame(width: 60, height: 50)
                .border(.blue, width: addBorder(buttonId: 3))
                .padding([.leading, .trailing])
            Button(action: {tutorial(buttonId: 3)}) {
                Text("?")
                    .foregroundColor(isTutorialSelected(buttonId: 3) ? .blue : .black)
                    .overlay(
                        Circle()
                            .stroke(isTutorialSelected(buttonId: 3) ? .blue : .black)
                            .frame(width: 20, height: 20)
                    )
            }
            .padding([.trailing])
            .scaleEffect(isTutorialSelected(buttonId: 3) ? 1.4 : 1.0)

        }
        .onChange(of: showConfirmationScreen) { _ in
            if showConfirmationScreen {
                showConfirmationScreen = true
            } else {
                showConfirmationScreen = false
            }
        }
        if showConfirmationTut{
            Text("Enabling this will add an extra, confirmation step in between navigating to new screens and typing characters")
                .foregroundColor(.blue)
                .padding([.leading, .trailing])
        }
    }
    
    private func tutorial(buttonId: Int) {
        // set bools based on the clicked button
        // turn on and off by blink clicking
        if showConfirmationTut {
            showConfirmationTut = false
        } else {
            showConfirmationTut = true
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

struct ShowConfirmSettingsView_Previews: PreviewProvider {
    static private var tempSelect = selectedState(buttonType: ButtonType.settingToggle, buttonId: 0, clickState: 0, isNo: false )
    
    static var previews: some View {
        ShowConfirmSettingsView(showConfirmationScreen: .constant(true), selectState: .constant(tempSelect), showConfirmationTut: .constant(false))
    }
}

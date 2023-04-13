//
//  DetectEyeView.swift
//  iTrackAlpha
//
//  Created by Andrew Herman on 4/12/23.
//

import SwiftUI
import AVFoundation

struct DetectEyeView: View {
    @Binding var detectSingleEye: Bool
    @Binding var detectRightEye: Bool
    @Binding var selectState: selectedState
    @Binding var showDetectEyeTut: Bool
    @State var audioPlayer: AVAudioPlayer!
    
    var body: some View {
        HStack{
            Text("Detect Single Eye")
                .foregroundColor(.black)
                .padding([.trailing, .leading])
            Spacer()
            Toggle(isOn: $detectSingleEye, label: {Text("")})
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .frame(width: 60, height: 50)
                .border(.blue, width: addBorder(buttonId: 4))
                .padding([.leading, .trailing])
            Button(action: {tutorial(buttonId: 4)}) {
                Text("?")
                    .foregroundColor(isTutorialSelected(buttonId: 4) ? .blue : .black)
                    .overlay(
                        Circle()
                            .stroke(isTutorialSelected(buttonId: 4) ? .blue : .black)
                            .frame(width: 20, height: 20)
                    )
            }
            .padding([.trailing])
            .scaleEffect(isTutorialSelected(buttonId: 4) ? 1.4 : 1.0)

        }
        .onChange(of: detectSingleEye) { _ in
            if detectSingleEye {
                detectSingleEye = true
            } else {
                detectSingleEye = false
            }
        }
        if detectSingleEye{ // Show another toggle switch when longerBlinkDelay is true
                        HStack {
                            Text("Detect Right Eye Only")
                                .foregroundColor(.black)
                                .padding([.trailing, .leading])
                            Spacer()
                            Toggle(isOn: $detectRightEye, label: { Text("") })
                                .labelsHidden()
                                .toggleStyle(SwitchToggleStyle(tint: .blue))
                                .frame(width: 60, height: 50)
                                .border(.blue, width: addBorder(buttonId: 5))
                                .padding([.leading, .trailing])
                        }
                        .padding([.leading, .trailing])
                        .onChange(of: detectRightEye) { _ in
                            if detectRightEye {
                                detectRightEye = true
                            } else {
                                detectRightEye = false
                            }
                        }
        }
        if showDetectEyeTut {
            Text("Enabling this will allow for detection of a single eye. Once enabled, \"Detect Right Eye Only\" will look at the movement only in your right eye. Disabling this will look at the movement only in your left eye.")
                .foregroundColor(.blue)
                .padding([.leading, .trailing])
        }
    }
    private func tutorial(buttonId: Int) {
        // set bools based on the clicked button
        // turn on and off by blink clicking
        if showDetectEyeTut {
            showDetectEyeTut = false
        } else {
            showDetectEyeTut = true
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

struct DetectEyeView_Previews: PreviewProvider {
    static private var tempSelect = selectedState(buttonType: ButtonType.settingToggle, buttonId: 0, clickState: 0, isNo: false )
    
    static var previews: some View {
        DetectEyeView(detectSingleEye: .constant(false), detectRightEye: .constant(false), selectState: .constant(tempSelect), showDetectEyeTut: .constant(false))
    }
}


//
//  SettingsView.swift
//  iTrackAlpha
//
//  Created by Danielle Maraffino on 3/12/23.
//

import SwiftUI
import AVFoundation

struct SettingsView: View {
    @Binding var longerBlinkDelay: Bool
    @Binding var longerGazeDelay: Bool
    @Binding var playSound: Bool
    @Binding var showConfirmationScreen: Bool
    @Binding var selectState: selectedState
    @Binding var queue: [Action]
    @Binding var value: Int
    @Binding var state: Int
    @State var audioPlayer: AVAudioPlayer!
    @State var showBlinkDelayTut: Bool = false
    @State var showGazeDelayTut: Bool = false
    @State var showSoundTut: Bool = false
    @State var showConfirmationTut: Bool = false
    
    var body: some View {
        VStack{
            Spacer()
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
                Text("blink delay tutorial")
                    .foregroundColor(.blue)
                    .padding([.leading, .trailing])
            }
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
                Text("gaze delay tutorial")
                    .foregroundColor(.blue)
                    .padding([.leading, .trailing])
            }
            HStack{
                Text("Play Sound on Blink")
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
                Text("play sound tutorial")
                    .foregroundColor(.blue)
                    .padding([.leading, .trailing])
            }
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
                Text("confirmation screen tutorial")
                    .foregroundColor(.blue)
                    .padding([.leading, .trailing])
            }
            Spacer()
        }
        .onChange(of: value ) { _ in
            if !queue.isEmpty {
                let action = queue.first!.actionType
                if action == ActionType.blink {
                    registerBlink()
                    queue.removeFirst()
                } else {
                    registerGaze(action: action)
                    queue.removeFirst()
                }
            }
        }
    }
    
    private func registerGaze(action: ActionType) {
        if action == ActionType.up {
            goUp()
        } else if action == ActionType.down {
            goDown()
        } else if action == ActionType.left {
            goLeft()
        } else if action == ActionType.right {
            goRight()
        }
    }
    
    private func goUp() {
        let curType = selectState.buttonType
        let curId = selectState.buttonId
        if (curType == ButtonType.settingToggle || curType == ButtonType.settingTurotial) && curId > 0{
            selectState.buttonId = curId - 1
        }
    }
    
    private func goDown() {
        let curType = selectState.buttonType
        let curId = selectState.buttonId
        if (curType == ButtonType.settingToggle || curType == ButtonType.settingTurotial) && curId < 3{
            selectState.buttonId = curId + 1
        }
    }
    
    private func goLeft() {
        let curType = selectState.buttonType
        if curType == ButtonType.settingToggle {
            selectState.buttonId = 0
            selectState.buttonType = ButtonType.cover
            state = 0
        } else if curType == ButtonType.settingTurotial {
            selectState.buttonType = ButtonType.settingToggle
        }
    }
    
    private func goRight() {
        let curType = selectState.buttonType
        if curType == ButtonType.settingToggle {
            selectState.buttonType = ButtonType.settingTurotial
        }
    }
    
    private func registerBlink() {
        let curType = selectState.buttonType
        let curId = selectState.buttonId
        if curType == ButtonType.settingToggle {
            if curId == 0 {
                if playSound {
                    makeSound()
                }
                if longerBlinkDelay {
                    longerBlinkDelay = false
                } else {
                    longerBlinkDelay = true
                }
            } else if curId == 1 {
                if playSound {
                    makeSound()
                }
                if longerGazeDelay {
                    longerGazeDelay = false
                } else {
                    longerGazeDelay = true
                }
            } else if curId == 2 {
                if playSound {
                    playSound = false
                } else {
                    makeSound()
                    playSound = true
                }
            } else if curId == 3 {
                if playSound {
                    makeSound()
                }
                if showConfirmationScreen {
                    showConfirmationScreen = false
                } else {
                    showConfirmationScreen = true
                }
            }
        } else if curType == ButtonType.settingTurotial {
            // call tutorial func to change bools to achieve lift off
            tutorial(buttonId: curId)
        }
    }
    
    private func tutorial(buttonId: Int) {
        // set bools based on the clicked button
        // turn on and off by blink clicking
        if buttonId == 0 {
            if showBlinkDelayTut {
                showBlinkDelayTut = false
            } else {
                showBlinkDelayTut = true
            }
        } else if buttonId == 1 {
            if showGazeDelayTut {
                showGazeDelayTut = false
            } else {
                showGazeDelayTut = true
            }
        } else if buttonId == 2 {
            if showSoundTut {
                showSoundTut = false
            } else {
                showSoundTut = true
            }
        } else if buttonId == 3 {
            if showConfirmationTut {
                showConfirmationTut = false
            } else {
                showConfirmationTut = true
            }
        }
    }
    
    private func isTutorialSelected(buttonId: Int) -> Bool{
        if selectState.buttonType == ButtonType.settingTurotial {
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
    
    private func changeGaze(isLarge: Bool) {
        if isLarge {
            longerGazeDelay = true
        } else {
            longerGazeDelay = false
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var tempSelect = selectedState(buttonType: ButtonType.settingToggle, buttonId: 0, clickState: 1, isNo: false)
    
    static var previews: some View {
        SettingsView(longerBlinkDelay: .constant(false), longerGazeDelay: .constant(false), playSound: .constant(true), showConfirmationScreen: .constant(true), selectState: .constant(tempSelect), queue: .constant([]), value: .constant(0), state: .constant(3))
    }
}

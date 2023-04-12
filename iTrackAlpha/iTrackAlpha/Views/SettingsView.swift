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
    @Binding var detectSingleEye: Bool
    @Binding var detectRightEye: Bool
    @Binding var selectState: selectedState
    @Binding var queue: [Action]
    @Binding var value: Int
    @Binding var state: Int
    @Binding var nextStateId: Int
    @Binding var prevState: Int
    @Binding var rowState: Int // for swipe right
    @State var audioPlayer: AVAudioPlayer!
    @State var showBlinkDelayTut: Bool = false
    @State var showGazeDelayTut: Bool = false
    @State var showSoundTut: Bool = false
    @State var showConfirmationTut: Bool = false
    @State var showDetectEyeTut: Bool = false
    @State var reload: Int = 0
    
    var body: some View {
        VStack{
            Text("Settings")
                .foregroundColor(.blue)
                .font(.title)
            Spacer()
            ExtendBlinkSettingsView(longerBlinkDelay: $longerBlinkDelay, selectState: $selectState, showBlinkDelayTut: $showBlinkDelayTut)
            ExtendGazeSettingsView(longerGazeDelay: $longerGazeDelay, selectState: $selectState, showGazeDelayTut: $showGazeDelayTut)
            PlaySoundSettingsView(playSound: $playSound, selectState: $selectState, showSoundTut: $showSoundTut)
            ShowConfirmSettingsView(showConfirmationScreen: $showConfirmationScreen, selectState: $selectState, showConfirmationTut: $showConfirmationTut)
            DetectEyeView(detectSingleEye: $detectSingleEye, detectRightEye: $detectRightEye, selectState: $selectState,
                showDetectEyeTut: $showDetectEyeTut)
            Button(action: {enterCalibration(fromBlink: false)}) {
                Text("Enter Sensitivity Calibration")
                    .frame(width: widthDim(), height: heightDim())
                    .foregroundColor(.black)
                    .background(Color(red: 0.83, green: 0.83, blue: 0.83))
                    .cornerRadius(8)
                    .border(.blue, width: addNewBorder())
                    .cornerRadius(8)
                    .padding()
            }
            Spacer()
        }
        .modifier(GestureSwipeRight(state: $state, selectState: $selectState, prevState: $prevState, rowState: $rowState))
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
        if (curType == ButtonType.settingToggle || curType == ButtonType.settingTutorial) && curId > 0{
            selectState.buttonId = curId - 1
        } else if curType == ButtonType.enterCalibration {
            selectState.buttonId = 3
            selectState.buttonType = ButtonType.settingToggle
        }
    }
    
    private func goDown() {
        let curType = selectState.buttonType
        let curId = selectState.buttonId
        if (curType == ButtonType.settingToggle || curType == ButtonType.settingTutorial) && curId < 3{
            selectState.buttonId = curId + 1
        } else if (curType == ButtonType.settingToggle || curType == ButtonType.settingTutorial) {
            selectState.buttonType = ButtonType.enterCalibration
            selectState.buttonId = 0
        }
    }
    
    private func goLeft() {
        let curType = selectState.buttonType
        if curType == ButtonType.settingToggle {
            if showConfirmationScreen {
                state = 4
                selectState.buttonType = ButtonType.confirm
                selectState.buttonId = 0
                selectState.isNo = false
                prevState = 3
                nextStateId = 0
            } else {
                selectState.buttonId = 0
                selectState.buttonType = ButtonType.cover
                state = 0
            }
        } else if curType == ButtonType.settingTutorial {
            selectState.buttonType = ButtonType.settingToggle
        }
    }
    
    private func goRight() {
        let curType = selectState.buttonType
        if curType == ButtonType.settingToggle {
            selectState.buttonType = ButtonType.settingTutorial
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
            else if curId == 4 {
                if playSound {
                    makeSound()
                }
                if detectSingleEye {
                    detectSingleEye = false
                } else {
                    detectSingleEye = true
                }
            }
        } else if curType == ButtonType.settingTutorial {
            // call tutorial func to change bools to achieve lift off
            if playSound {
                makeSound()
            }
            tutorial(buttonId: curId)
        } else if curType == ButtonType.enterCalibration {
            if playSound {
                makeSound()
            }
            enterCalibration(fromBlink: true)
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
        } else if buttonId == 4 {
            if showDetectEyeTut {
                showDetectEyeTut = false
            } else {
                showDetectEyeTut = true
            }
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
    
    // functions below only used by enter calibration button
    // TODO add looking functionality for this button
    private func addNewBorder() -> CGFloat {
        if selectState.buttonType == ButtonType.enterCalibration {
            return 3.0
        } else {
            return 0.0
        }
    }
    
    private func widthDim() -> CGFloat {
        if selectState.buttonType == ButtonType.enterCalibration {
            return 200
        } else {
            return 160
        }
    }
    
    private func heightDim() -> CGFloat {
        if selectState.buttonType == ButtonType.enterCalibration {
            return 85
        } else {
            return 55
        }
    }
    
    private func enterCalibration(fromBlink: Bool) {
        let curType = selectState.buttonType
        if curType == ButtonType.enterCalibration || !fromBlink {
            if showConfirmationScreen {
                state = 4
                selectState.buttonType = ButtonType.confirm
                selectState.buttonId = 0
                selectState.isNo = false
                prevState = 3
                nextStateId = 7
            } else {
                selectState.buttonId = 0
                selectState.buttonType = ButtonType.calibration
                state = 7
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var tempSelect = selectedState(buttonType: ButtonType.settingToggle, buttonId: 0, clickState: 1, isNo: false)
    
    static var previews: some View {
        SettingsView(longerBlinkDelay: .constant(false), longerGazeDelay: .constant(false), playSound: .constant(true), showConfirmationScreen: .constant(true), detectSingleEye: .constant(false), detectRightEye: .constant(false), selectState: .constant(tempSelect), queue: .constant([]), value: .constant(0), state: .constant(3), nextStateId: .constant(0), prevState: .constant(3), rowState: .constant(0))
    }
}

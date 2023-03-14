//
//  SettingsView.swift
//  iTrackAlpha
//
//  Created by Danielle Maraffino on 3/12/23.
//

import SwiftUI

struct SettingsView: View {
    @Binding var blinkDelay: CGFloat
    @Binding var gazeDelay: CGFloat
    @Binding var playSound: Bool
    @Binding var showConfirmationScreen: Bool
    @Binding var selectState: selectedState
    @Binding var queue: [Action]
    @Binding var value: Int
    @Binding var state: Int
    @State var longerBlinkDelay: Bool = false
    @State var longerGazeDelay: Bool = false
    @State var playSoundToggleOn: Bool = true
    @State var showConfirmationToggleOn: Bool = true
    
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

            }
            .onChange(of: longerBlinkDelay) { longerBlinkDelay in
                if longerBlinkDelay {
                    blinkDelay = 2.0
                } else {
                    blinkDelay = 1.0
                }
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
            }
            .onChange(of: longerGazeDelay) { longerGazeDelay in
                if longerGazeDelay {
                    gazeDelay = 2.0
                } else {
                    gazeDelay = 1.0
                }
            }
            HStack{
                Text("Play Sound on Blink")
                    .foregroundColor(.black)
                    .padding([.leading, .trailing])
                Spacer()
                Toggle(isOn: $playSoundToggleOn, label: {Text("")})
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                    .frame(width: 60, height: 50)
                    .border(.blue, width: addBorder(buttonId: 2))
                    .padding([.leading, .trailing])

            }
            .onChange(of: playSoundToggleOn) { playSoundOn in
                print("in change playSound")
                if playSoundToggleOn {
                    playSound = false
                } else {
                    playSound = true
                }
            }
            HStack{
                Text("Show Confirmation Screen")
                    .foregroundColor(.black)
                    .padding([.leading, .trailing])
                Spacer()
                Toggle("", isOn: $showConfirmationToggleOn)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                    .frame(width: 60, height: 50)
                    .border(.blue, width: addBorder(buttonId: 3))
                    .padding([.leading, .trailing])

            }
            .onChange(of: showConfirmationToggleOn) { showConfirmationToggleOn in
                if showConfirmationToggleOn {
                    showConfirmationScreen = false
                } else {
                    showConfirmationScreen = true
                }
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
            print(playSound)
        }
    }
    
    private func goUp() {
        let curType = selectState.buttonType
        let curId = selectState.buttonId
        if curType == ButtonType.settingToggle && curId > 0{
            selectState.buttonId = curId - 1
        }
    }
    
    private func goDown() {
        let curType = selectState.buttonType
        let curId = selectState.buttonId
        if curType == ButtonType.settingToggle && curId < 3{
            selectState.buttonId = curId + 1
        }
    }
    
    private func goLeft() {
        // go back to cover screen eventually
        selectState.buttonId = 0
        selectState.buttonType = ButtonType.cover
        state = 0
    }
    
    private func registerBlink() {
        let curId = selectState.buttonId
        if curId == 0 {
            if longerBlinkDelay {
                longerBlinkDelay = false
            } else {
                longerBlinkDelay = true
            }
        } else if curId == 1 {
            if longerGazeDelay {
                longerGazeDelay = false
            } else {
                longerGazeDelay = true
            }
        } else if curId == 2 {
            if playSoundToggleOn {
                playSoundToggleOn = false
            } else {
                playSoundToggleOn = true
            }
        } else if curId == 3 {
            if showConfirmationToggleOn {
                showConfirmationToggleOn = false
            } else {
                showConfirmationToggleOn = true
            }
        }
    }
    
    private func changeBlink(isLarge: Bool) {
        if isLarge {
            blinkDelay = 2.0
        } else {
            blinkDelay = 1.0
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
            gazeDelay = 2.0
        } else {
            gazeDelay = 1.0
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var tempSelect = selectedState(buttonType: ButtonType.settingToggle, buttonId: 0, clickState: 1, isNo: false)
    
    static var previews: some View {
        SettingsView(blinkDelay: .constant(1.0), gazeDelay: .constant(1.0), playSound: .constant(true), showConfirmationScreen: .constant(true), selectState: .constant(tempSelect), queue: .constant([]), value: .constant(0), state: .constant(3))
    }
}

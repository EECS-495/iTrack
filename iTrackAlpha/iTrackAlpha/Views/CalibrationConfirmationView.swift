//
//  CalibrationConfirmationView.swift
//  iTrackAlpha
//
//  Created by Danielle Maraffino on 4/11/23.
//

import SwiftUI
import AVFoundation

struct CalibrationConfirmationView: View {
    @Binding var calibrationState: CalibrationState
    @Binding var selectState: selectedState
    @Binding var queue: [Action]
    @Binding var value: Int
    @Binding var lookUpSens: CGFloat // connected to the customization sensitivities
    @Binding var lookDownSens: CGFloat
    @Binding var lookLeftSens: CGFloat
    @Binding var lookRightSens: CGFloat
    @Binding var blinkSens: CGFloat
    @Binding var origLookUp: CGFloat
    @Binding var origLookDown: CGFloat
    @Binding var origLookLeft: CGFloat
    @Binding var origLookRight: CGFloat
    @Binding var origBlink: CGFloat
    @Binding var inCalibrationConfirmation: Bool
    @Binding var playSound: Bool
    @State var audioPlayer: AVAudioPlayer!
    @State var sensIncrement: CGFloat = 0.1
    @State var showConfirmHelp: Bool = false
    @State var showIncHelp: Bool = false
    @State var showDecHelp: Bool = false
    @State var showExitHelp: Bool = false
    // TODO make pretty and make text appear to the left of the buttons after the user selects the help button
    var body: some View {
        VStack{
            HStack {
                Button(action: {confirmSens(fromBlink: false)}){
                    Text("Confirm \(direction()) Sensitivity")
                }
                .frame(width: widthDim(id: 0), height: heightDim(id: 0))
                .foregroundColor(.black)
                .background(Color(red: 0.83, green: 0.83, blue: 0.83))
                .cornerRadius(8)
                .border(.blue, width: addNewBorder(id: 0))
                .cornerRadius(8)
                .padding()
                Button(action: {flipHelp(id: 0)}) {
                    Text("?")
                        .foregroundColor(isTutorialHighlighted(id: 0) ? .blue : .black)
                        .overlay(
                            Circle()
                                .stroke(isTutorialHighlighted(id: 0) ? Color.blue : Color.black, lineWidth: isTutorialHighlighted(id: 0) ? 2.0 : 1.0)
                                .frame(width: isTutorialHighlighted(id: 0) ? 30: 20, height: isTutorialHighlighted(id: 0) ? 30: 20)
                        )
                }
                .padding()
            }
            if showConfirmHelp {
                Text("If satisfied with sensitivity for \(direction()), select the Confirm button to exit and save changes")
                    .padding()
                    .foregroundColor(.blue)
            }
            HStack {
                Button(action: {increaseSens(fromBlink: false)}){
                    Text("Increase \(direction()) Sensitivity")
                }
                .frame(width: widthDim(id: 1), height: heightDim(id: 1))
                .foregroundColor(.black)
                .background(Color(red: 0.83, green: 0.83, blue: 0.83))
                .cornerRadius(8)
                .border(.blue, width: addNewBorder(id: 1))
                .cornerRadius(8)
                .padding()
                Button(action: {flipHelp(id: 1)}) {
                    Text("?")
                        .foregroundColor(isTutorialHighlighted(id: 1) ? .blue : .black)
                        .overlay(
                            Circle()
                                .stroke(isTutorialHighlighted(id: 1) ? Color.blue : Color.black, lineWidth: isTutorialHighlighted(id: 1) ? 2.0 : 1.0)
                                .frame(width: isTutorialHighlighted(id: 1) ? 30: 20, height: isTutorialHighlighted(id: 1) ? 30: 20)
                        )
                }
                .padding()
            }
            if showIncHelp {
                Text("If triggering response from app while \(direction()) was difficult, select the Increase button")
                    .padding()
                    .foregroundColor(.blue)
            }
            HStack {
                Button(action: {decreaseSens(fromBlink: false)}){
                    Text("Decrease \(direction()) Sensitivity")
                }
                .frame(width: widthDim(id: 2), height: heightDim(id: 2))
                .foregroundColor(.black)
                .background(Color(red: 0.83, green: 0.83, blue: 0.83))
                .cornerRadius(8)
                .border(.blue, width: addNewBorder(id: 2))
                .cornerRadius(8)
                .padding()
                Button(action: {flipHelp(id: 2)}) {
                    Text("?")
                        .foregroundColor(isTutorialHighlighted(id: 2) ? .blue : .black)
                        .overlay(
                            Circle()
                                .stroke(isTutorialHighlighted(id: 2) ? Color.blue : Color.black, lineWidth: isTutorialHighlighted(id: 2) ? 2.0 : 1.0)
                                .frame(width: isTutorialHighlighted(id: 2) ? 30: 20, height: isTutorialHighlighted(id: 2) ? 30: 20)
                        )
                }
                .padding()
            }
            if showDecHelp {
                Text("If triggering response from app while \(direction()) was too sensitive, select the Decrease button")
                    .padding()
                    .foregroundColor(.blue)
            }
            HStack {
                Button(action: {exitCalibrationConf(fromBlink: false)}){
                    Text("Exit and Discard Changes")
                }
                .frame(width: widthDim(id: 3), height: heightDim(id: 3))
                .foregroundColor(.black)
                .background(Color(red: 0.83, green: 0.83, blue: 0.83))
                .cornerRadius(8)
                .border(.blue, width: addNewBorder(id: 3))
                .cornerRadius(8)
                .padding()
                Button(action: {flipHelp(id: 3)}) {
                    Text("?")
                        .foregroundColor(isTutorialHighlighted(id: 3) ? .blue : .black)
                        .overlay(
                            Circle()
                                .stroke(isTutorialHighlighted(id: 3) ? Color.blue : Color.black, lineWidth: isTutorialHighlighted(id: 3) ? 2.0 : 1.0)
                                .frame(width: isTutorialHighlighted(id: 3) ? 30: 20, height: isTutorialHighlighted(id: 3) ? 30: 20)
                        )
                }
                .padding()
            }
            if showExitHelp {
                Text("To exit the calibration process and revert changes, select the Exit button ")
                    .padding()
                    .foregroundColor(.blue)
            }
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
    
    private func direction() -> String {
        if calibrationState == CalibrationState.up {
            return "looking up"
        } else if calibrationState == CalibrationState.down {
            return "looking down"
        } else if calibrationState == CalibrationState.left {
            return "looking left"
        } else if calibrationState == CalibrationState.right {
            return "looking right"
        } else if calibrationState == CalibrationState.blink {
            return "blinking"
        } else {
            return "INVALID CALIBRATION STATE IN CalibrationConfirmationView"
        }
    }
    
    private func increaseSens(fromBlink: Bool) {
        // increase sensitivity means a low number for look[]Sens
        // go back to calibration
        if playSound {
            makeSound()
        }
        if calibrationState == CalibrationState.up {
            if lookUpSens > 0 {
                lookUpSens = lookUpSens - sensIncrement
            }
        } else if calibrationState == CalibrationState.down {
            if lookDownSens > 0 {
                lookDownSens = lookDownSens - sensIncrement
            }
        } else if calibrationState == CalibrationState.left {
            if lookLeftSens > 0 {
                lookLeftSens = lookLeftSens - sensIncrement
            }
        } else if calibrationState == CalibrationState.right {
            if lookRightSens > 0 {
                lookRightSens = lookRightSens - sensIncrement
            }
        } else if calibrationState == CalibrationState.blink {
            if blinkSens > 0 {
                blinkSens = blinkSens - sensIncrement
            }
        }
        inCalibrationConfirmation = false
    }
    
    private func decreaseSens(fromBlink: Bool) {
        // decrease sensitivity means a high number for look[]Sens
        // go back to calibration
        if playSound {
            makeSound()
        }
        if calibrationState == CalibrationState.up {
            if lookUpSens < 1 {
                lookUpSens = lookUpSens + sensIncrement
            }
        } else if calibrationState == CalibrationState.down {
            if lookDownSens < 1 {
                lookDownSens = lookDownSens + sensIncrement
            }
        } else if calibrationState == CalibrationState.left {
            if lookLeftSens < 1 {
                lookLeftSens = lookLeftSens + sensIncrement
            }
        } else if calibrationState == CalibrationState.right {
            if lookRightSens < 1 {
                lookRightSens = lookRightSens + sensIncrement
            }
        } else if calibrationState == CalibrationState.blink {
            if blinkSens < 1 {
                blinkSens = blinkSens + sensIncrement
            }
        }
        inCalibrationConfirmation = false
    }
    
    private func confirmSens(fromBlink: Bool) {
        // saves changes and exits to calibration buttons
        inCalibrationConfirmation = false
        calibrationState = CalibrationState.buttons
        selectState.buttonId = 0
        selectState.buttonType = ButtonType.calibration
    }
    
    private func exitCalibrationConf(fromBlink: Bool) {
        // restore look[]Sens to orig[]Sens values
        if calibrationState == CalibrationState.up {
            lookUpSens = origLookUp
        } else if calibrationState == CalibrationState.down {
            lookDownSens = origLookDown
        } else if calibrationState == CalibrationState.left {
            lookLeftSens = origLookLeft
        } else if calibrationState == CalibrationState.right {
            lookRightSens = origLookRight
        } else if calibrationState == CalibrationState.blink {
            blinkSens = origBlink
        }
        inCalibrationConfirmation = false
        calibrationState = CalibrationState.buttons
        selectState.buttonId = 0
        selectState.buttonType = ButtonType.calibration
    }
    // TODO add check for type
    private func registerBlink() {
        // check if select state matches before calling functions
        let curId = selectState.buttonId
        if curId == 0 {
            // on confirm button
            confirmSens(fromBlink: true)
        } else if curId == 1 {
            increaseSens(fromBlink: true)
        } else if curId == 2 {
            decreaseSens(fromBlink: true)
        } else if curId == 3 {
            exitCalibrationConf(fromBlink: true)
        }
    }
    // TODO add functionality for help buttons
    private func registerGaze(action: ActionType){
        if action == ActionType.up {
            if selectState.buttonId != 0 {
                selectState.buttonId = selectState.buttonId - 1
            }
            // leaving room for adding help button here
        } else if action == ActionType.down {
            if selectState.buttonId < 3 {
                selectState.buttonId = selectState.buttonId + 1
            }
        }
    }
    
    private func addNewBorder(id: Int) -> CGFloat {
        if selectState.buttonType == ButtonType.calibrationConf && selectState.buttonId == id{
            return 3.0
        } else {
            return 0.0
        }
    }
    
    private func widthDim(id: Int) -> CGFloat {
        if selectState.buttonType == ButtonType.calibrationConf && selectState.buttonId == id {
            return 220
        } else {
            return 180
        }
    }
    
    private func heightDim(id: Int) -> CGFloat {
        if selectState.buttonType == ButtonType.calibrationConf && selectState.buttonId == id {
            return 85
        } else {
            return 55
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
    
    private func flipHelp(id: Int) {
        if id == 0 {
            if showConfirmHelp {
                showConfirmHelp = false
            } else {
                showConfirmHelp = true
            }
        } else if id == 1 {
            if showIncHelp {
                showIncHelp = false
            } else {
                showIncHelp = true
            }
        } else if id == 2 {
            if showDecHelp {
                showDecHelp = false
            } else {
                showDecHelp = true
            }
        } else if id == 3 {
            if showExitHelp {
                showExitHelp = false
            } else {
                showExitHelp = true
            }
        }
    }
    
    private func isTutorialHighlighted(id: Int) -> Bool {
        if selectState.buttonType == ButtonType.calibConfHelp {
            if selectState.buttonId == id {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}

struct CalibrationConfirmationView_Previews: PreviewProvider {
    static var tempSelect = selectedState(buttonType: ButtonType.calibrationConf, buttonId: 0, clickState: 1, isNo: false)
    
    static var previews: some View {
        CalibrationConfirmationView(calibrationState: .constant(CalibrationState.down), selectState: .constant(tempSelect), queue: .constant([]), value: .constant(0), lookUpSens: .constant(0.7), lookDownSens: .constant(0.35), lookLeftSens: .constant(0.7), lookRightSens: .constant(0.7),blinkSens: .constant(0.9), origLookUp: .constant(0.7), origLookDown: .constant(0.35), origLookLeft: .constant(0.7), origLookRight: .constant(0.7), origBlink: .constant(0.9), inCalibrationConfirmation: .constant(true), playSound: .constant(true))
    }
}

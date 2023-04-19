//
//  CalibrationButtonsView.swift
//  iTrackAlpha
//
//  Created by Danielle Maraffino on 4/10/23.
//

import SwiftUI

struct CalibrationButtonsView: View {
    @Binding var state: Int
    @Binding var calibrationState: CalibrationState
    @Binding var selectState: selectedState
    @Binding var queue: [Action]
    @Binding var value: Int
    @Binding var showConfirmationScreen: Bool
    @Binding var nextStateId: Int
    @Binding var prevState: Int
    @Binding var playSound: Bool
    @Binding var lookUpSens: CGFloat
    @Binding var lookDownSens: CGFloat
    @Binding var lookLeftSens: CGFloat
    @Binding var lookRightSens: CGFloat
    @Binding var blinkSens: CGFloat
    @Binding var defaultUp: CGFloat
    @Binding var defaultDown: CGFloat
    @Binding var defaultLeft: CGFloat
    @Binding var defaultRight: CGFloat
    @Binding var defaultBlink: CGFloat
    @State var showTutorial: Bool = false
    
    var body: some View {
        VStack{ // use padding instead of spacers if there are too many objects
            if showTutorial {
                Text("Use the buttons below to adjust sensitivities")
                    .padding(3)
                    .foregroundColor(.blue)
                Text("Dramatic eye actions will make calibration more effective")
                    .padding(3)
                    .foregroundColor(.blue)
            }
            Button(action: {showCalibTut()}) {
                Text("?")
                    .foregroundColor(selectState.buttonType == ButtonType.calibHelp ? .blue : .black)
                    .overlay(
                        Circle()
                            .stroke(selectState.buttonType == ButtonType.calibHelp ? Color.blue : Color.black, lineWidth: selectState.buttonType == ButtonType.calibHelp ? 2.0 : 1.0)
                            .frame(width: selectState.buttonType == ButtonType.calibHelp ? 30: 20, height: selectState.buttonType == ButtonType.calibHelp ? 30: 20)
                    )
            }
            Button(action: {enterLookUp()}){
                Text("Adjust Look Up")
            }
            .frame(width: widthDim(id: 0), height: heightDim(id: 0))
            .foregroundColor(.black)
            .background(Color(red: 0.83, green: 0.83, blue: 0.83))
            .cornerRadius(8)
            .border(.blue, width: addNewBorder(id: 0))
            .cornerRadius(8)
            .padding(3)
            
            Button(action: {enterLookDown()}){
                Text("Adjust Look Down")
            }
            .frame(width: widthDim(id: 1), height: heightDim(id: 1))
            .foregroundColor(.black)
            .background(Color(red: 0.83, green: 0.83, blue: 0.83))
            .cornerRadius(8)
            .border(.blue, width: addNewBorder(id: 1))
            .cornerRadius(8)
            .padding(3)
            Button(action: {enterLookLeft()}){
                Text("Adjust Look Left")
            }
            .frame(width: widthDim(id: 2), height: heightDim(id: 2))
            .foregroundColor(.black)
            .background(Color(red: 0.83, green: 0.83, blue: 0.83))
            .cornerRadius(8)
            .border(.blue, width: addNewBorder(id: 2))
            .cornerRadius(8)
            .padding(3)
            Button(action: {enterLookRight()}){
                Text("Adjust Look Right")
            }
            .frame(width: widthDim(id: 3), height: heightDim(id: 3))
            .foregroundColor(.black)
            .background(Color(red: 0.83, green: 0.83, blue: 0.83))
            .cornerRadius(8)
            .border(.blue, width: addNewBorder(id: 3))
            .cornerRadius(8)
            .padding(3)
            Button(action: {enterBlink()}){
                Text("Adjust Blink")
            }
            .frame(width: widthDim(id: 4), height: heightDim(id: 4))
            .foregroundColor(.black)
            .background(Color(red: 0.83, green: 0.83, blue: 0.83))
            .cornerRadius(8)
            .border(.blue, width: addNewBorder(id: 4))
            .cornerRadius(8)
            .padding(3)
            Button(action: {restoreDefaults()}){
                Text("Restore Defaults")
            }
            .frame(width: widthDim(id: 5), height: heightDim(id: 5))
            .foregroundColor(.black)
            .background(Color(red: 0.83, green: 0.83, blue: 0.83))
            .cornerRadius(8)
            .border(.blue, width: addNewBorder(id: 5))
            .cornerRadius(8)
            .padding(3)
            Button(action: {exitCalibration()}){
                Text("Save and Exit")
            }
            .frame(width: widthDim(id: 6), height: heightDim(id: 6))
            .foregroundColor(.black)
            .background(Color(red: 0.83, green: 0.83, blue: 0.83))
            .cornerRadius(8)
            .border(.blue, width: addNewBorder(id: 6))
            .cornerRadius(8)
            .padding(3)
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
    
    private func enterLookUp() {
        // changes the view to the look up calibration
        // TO DO possibly change selectState here later
        calibrationState = CalibrationState.up
    }
    
    private func enterLookDown() {
        // changes the view to the look down calibration
        // TO DO possibly change selectState here later
        calibrationState = CalibrationState.down
    }
    
    private func enterLookLeft() {
        // changes the view to the look left calibration
        // TO DO possibly change selectState here later
        calibrationState = CalibrationState.left
    }
    
    private func enterLookRight() {
        // changes the view to the look right calibration
        // TO DO possibly change selectState here later
        calibrationState = CalibrationState.right
    }
    
    private func enterBlink() {
        // changes the view to the blink calibration
        // TO DO possibly change selectState here later
        calibrationState = CalibrationState.blink
    }
    
    private func restoreDefaults() {
        lookUpSens = defaultUp
        lookDownSens = defaultDown
        lookLeftSens = defaultLeft
        lookRightSens = defaultRight
    }
    
    private func showCalibTut() {
        if showTutorial {
            showTutorial = false
        } else {
            showTutorial = true
        }
    }
    
    private func exitCalibration() {
        // TODO
        if showConfirmationScreen {
            state = 4
            selectState.buttonType = ButtonType.confirm
            selectState.buttonId = 0
            selectState.isNo = false
            prevState = 7
            nextStateId = 3
        } else {
            selectState.buttonId = 0
            selectState.buttonType = ButtonType.settingToggle
            state = 3
        }
    }
    
    private func registerBlink() {
        if selectState.buttonType == ButtonType.calibration {
            if selectState.buttonId == 0 {
                enterLookUp()
            } else if selectState.buttonId == 1 {
                enterLookDown()
            } else if selectState.buttonId == 2 {
                enterLookLeft()
            } else if selectState.buttonId == 3 {
                enterLookRight()
            } else if selectState.buttonId == 4 {
                enterBlink()
            } else if selectState.buttonId == 5 {
                restoreDefaults()
            } else if selectState.buttonId == 6 {
                exitCalibration()
            }
        } else if selectState.buttonType == ButtonType.calibHelp {
            showCalibTut()
        }
    }
    
    private func registerGaze(action: ActionType){
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
        if selectState.buttonType == ButtonType.calibration {
            if selectState.buttonId > 0 {
                selectState.buttonId = selectState.buttonId - 1
            } else if selectState.buttonId == 0 {
                selectState.buttonType = ButtonType.calibHelp
                selectState.buttonId = 0
            }
        }
    }
    
    private func goDown() {
        if selectState.buttonType == ButtonType.calibration {
            if selectState.buttonId < 6 {
                selectState.buttonId = selectState.buttonId + 1
            }
        } else if selectState.buttonType == ButtonType.calibHelp {
            selectState.buttonType = ButtonType.calibration
            selectState.buttonId = 0
        }
    }
    
    private func goRight() {
        // to do later if we decide to have look right functionality
    }
    
    private func goLeft() {
        // go back to settings screen
        let curType = selectState.buttonType
        if curType == ButtonType.calibration {
            if showConfirmationScreen {
                state = 4
                selectState.buttonType = ButtonType.confirm
                selectState.buttonId = 0
                selectState.isNo = false
                prevState = 7
                nextStateId = 3
            } else {
                selectState.buttonId = 0
                selectState.buttonType = ButtonType.settingToggle
                state = 3
            }
        }
    }
    
    private func addNewBorder(id: Int) -> CGFloat {
        if selectState.buttonType == ButtonType.calibration && selectState.buttonId == id{
            return 3.0
        } else {
            return 0.0
        }
    }
    
    private func widthDim(id: Int) -> CGFloat {
        if selectState.buttonType == ButtonType.calibration && selectState.buttonId == id {
            return 200
        } else {
            return 160
        }
    }
    
    private func heightDim(id: Int) -> CGFloat {
        if selectState.buttonType == ButtonType.calibration && selectState.buttonId == id {
            return 85
        } else {
            return 55
        }
    }
}

struct CalibrationButtonsView_Previews: PreviewProvider {
    static var tempSelect = selectedState(buttonType: ButtonType.calibration, buttonId: 0, clickState: 1, isNo: false)
    
    static var previews: some View {
        CalibrationButtonsView(state: .constant(7), calibrationState: .constant(CalibrationState.buttons), selectState: .constant(tempSelect), queue: .constant([]), value: .constant(0), showConfirmationScreen: .constant(true), nextStateId: .constant(0), prevState: .constant(7), playSound: .constant(true), lookUpSens: .constant(0.7), lookDownSens: .constant(0.35), lookLeftSens: .constant(0.7), lookRightSens: .constant(0.7), blinkSens: .constant(0.9), defaultUp: .constant(0.7), defaultDown: .constant(0.35), defaultLeft: .constant(0.7), defaultRight: .constant(0.7), defaultBlink: .constant(0.9))
    }
}

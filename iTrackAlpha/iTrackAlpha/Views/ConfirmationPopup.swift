//
//  ConfirmationPopup.swift
//  Track
//
//  Created by Amanda Beger on 2/7/23.
//

import SwiftUI
import AVFoundation

struct ConfirmationPopup: View {
    @State var audioPlayer: AVAudioPlayer!
    @Binding var state: Int
    @Binding var rowState: Int
    @Binding var charState: Int
    @Binding var prevState: Int
    @Binding var nextStateId: Int
    @Binding var selectState: selectedState
    @Binding var content: String
    @Binding var contentInd: Int
    @Binding var queue: [Action]
    @Binding var value: Int
    @Binding var highlightBackspace: Bool
    @Binding var highlightCursor: Bool
    @Binding var playSound: Bool
    @Binding var customState: String
    @Binding var showSave: Bool
    @Binding var customList: [CustomPhrase]
    @Binding var prevButtonType: ButtonType
    @Binding var lookLeft: Bool
        
    
    var body: some View {
        
        VStack {
            
            // transition everything to use nextState?
            if nextStateId == 0 {
                if prevState == 5 && !lookLeft {
                    Text(customPhraseText())
                        .foregroundColor(.black)
                } else {
                    Text("Did you mean to return to the home screen?")
                        .foregroundColor(.black)
                }
            } else if nextStateId == 1 && prevState == 2 {
                // going to row view after selecting a char
                Text(charConfirmText())
                    .foregroundColor(.black)
            } else if nextStateId == 1 {
                // next state is rows
                Text(coverConfirmText())
                    .foregroundColor(.black)
            } else if nextStateId == 2 {
                // next state is char
                Text(rowConfirmText())
                    .foregroundColor(.black)
            } else if nextStateId == 3 {
                // next state is settings
                Text(settingsConfirmText())
                    .foregroundColor(.black)
            } else if nextStateId == 5 {
                // next state is custom phrases
                if (prevButtonType == ButtonType.addNewPhrase) {
                    Text(addNewPhraseText())
                        .foregroundColor(.black)
                } else if (prevButtonType == ButtonType.exit) {
                    Text("Did you mean to exit?")
                        .foregroundColor(.black)
                } else {
                    Text("Did you mean to enter custom phrases?")
                        .foregroundColor(.black)
                }
            } else if nextStateId == 6 {
                // next state is tutorial
                Text(tutorialConfirmText())
                    .foregroundColor(.black)
            } else if nextStateId == 7 {
                Text("Did you mean to enter the sensitivity calibration?")
                    .foregroundColor(.black)
            }
            /* old approach without nextStateId
            if prevState == 0 {
                Text(coverConfirmText())
                    .foregroundColor(.black)
            } else if prevState == 1 {
                Text(rowConfirmText())
                    .foregroundColor(.black)
            } else if prevState == 2 {
                Text(charConfirmText())
                    .foregroundColor(.black)
            } else if prevState == 5 {
                Text(customPhraseText())
                    .foregroundColor(.black)
            } */
            
            HStack {
                Button(action: nextState) {
                    Text("Yes")
                        .frame(width: scaleDim(isNo: false), height: scaleDim(isNo: false))
                        .border(.blue, width: addBorder(isNo: false))
                        .foregroundColor(.black)
                        .background(Color(red: 0.83, green: 0.83, blue: 0.83))
                        .cornerRadius(8)
                }
                Button(action: lastState) {
                    Text("No")
                        .frame(width: scaleDim(isNo: true), height: scaleDim(isNo: true))
                        .border(.blue, width: addBorder(isNo: true))
                        .foregroundColor(.black)
                        .background(Color(red: 0.83, green: 0.83, blue: 0.83))
                        .cornerRadius(8)
                }
            }
        }
        .onChange(of: value ) { _ in
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
    
    private func registerBlink() {
        if selectState.buttonType == ButtonType.backspace {
            // go to deleteChar
            deleteChar()
        } else {
            if !selectState.isNo {
                // yes button "clicked"
                // go to nextState
                nextState()
            } else {
                // no button
                // go to last state
                lastState()
            }
        }
    }
    
    private func deleteChar() {
        if contentInd > 0 {
            if playSound {
                makeSound()
            }
            var count: Int = 0
            var content1: String = ""
            var content2: String = ""
            for char in Array(content) {
                if count >= contentInd - 1 {
                    break
                }
                content1 = content1 + String(char)
                count = count + 1
            }
            count = 0
            for char in Array(content) {
                if count >= contentInd {
                    content2 = content2 + String(char)
                }
                count = count + 1
            }
            content = content1 + content2
            contentInd = contentInd - 1
        }
    }
    
    private func registerGaze(action: ActionType) {
        if action == ActionType.up {
            if selectState.buttonType == ButtonType.confirm {
                // go to backspace
                goToBackspace()
            }
        } else if action == ActionType.down {
            let curType = selectState.buttonType
            if curType == ButtonType.backspace {
                // go to yes
                highlightBackspace = false
                goToYes()
            } else if curType == ButtonType.cursor {
                highlightCursor = false
                goToYes()
            }
        } else if action == ActionType.right {
            let curType = selectState.buttonType
            if curType == ButtonType.confirm && !selectState.isNo {
                // go to no
                goToNo()
            } else if curType == ButtonType.cursor {
                if contentInd == content.count {
                    highlightCursor = false
                    goToBackspace()
                } else {
                    moveCursorRight()
                }
            }
        } else if action == ActionType.left {
            let curType = selectState.buttonType
            if curType == ButtonType.confirm && selectState.isNo {
                // go to yes
                goToYes()
            } else if curType == ButtonType.backspace {
                if content.count > 0 {
                    highlightBackspace = false
                    goToCursor()
                }
            } else if curType == ButtonType.cursor {
                moveCursorLeft()
            }
        }
    }
    
    private func goToBackspace() {
        selectState.clickState = 1
        selectState.buttonType = ButtonType.backspace
        highlightBackspace = true
    }
    
    private func goToYes() {
        selectState.clickState = 1
        selectState.buttonType = ButtonType.confirm
        selectState.isNo = false
    }
    
    private func goToNo() {
        selectState.clickState = 1
        selectState.buttonType = ButtonType.confirm
        selectState.isNo = true
    }
    
    private func goToCursor() {
        highlightCursor = true
        selectState.clickState = 1
        selectState.buttonId = 0
        selectState.buttonType = ButtonType.cursor
    }
    
    private func moveCursorLeft() {
        if contentInd > 0 {
            contentInd = contentInd - 1
        }
    }
    
    private func moveCursorRight() {
        if contentInd < content.count {
            contentInd = contentInd + 1
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
    
    private func nextState() {
        if nextStateId == 0 && prevState != 5 {
            // go to cover buttons
            state = 0
            selectState.buttonType = ButtonType.cover
            selectState.buttonId = 0
            selectState.clickState = 1
        } else if prevState == 2 && nextStateId == 1 {
            // add text to content then going to rows
            print("in add char in confirm")
            var count: Int = 0
            var content1: String = ""
            var content2: String = ""
            let character = CharRows.filter { row in
                row.id == selectState.buttonId
            }[0]
            for char in Array(content) {
                if count >= contentInd {
                    break
                }
                content1 = content1 + String(char)
                count = count + 1
            }
            count = 0
            for char in Array(content) {
                if count >= contentInd {
                    content2 = content2 + String(char)
                }
                count = count + 1
            }
            content = content1 + character.character + content2
            contentInd = contentInd + 1
            state = 1
            selectState.clickState = 1
            selectState.buttonType = ButtonType.row
            selectState.buttonId = getFirstRow()
        } else if nextStateId == 1 {
            // going to rows
            state = 1
            selectState.clickState = 1
            selectState.buttonType = ButtonType.row
            selectState.buttonId = getFirstRow()
        } else if nextStateId == 2 {
            // going to char
            state = 2
            selectState.clickState = 1
            selectState.buttonType = ButtonType.char
            selectState.buttonId = getFirstChar()
        } else if prevState == 5 && !lookLeft {
            var count: Int = 0
            var content1: String = ""
            var content2: String = ""
            for char in Array(content) {
                if count >= contentInd {
                    break
                }
                content1 = content1 + String(char)
                count = count + 1
            }
            count = 0
            for char in Array(content) {
                if count >= contentInd {
                    content2 = content2 + String(char)
                }
                count = count + 1
            }
            content = content1 + customState + content2
            contentInd = contentInd + customState.count
            
            selectState.clickState = 1
            selectState.buttonType = ButtonType.cover
            selectState.buttonId = 0
            state = 0
        } else if nextStateId == 3 {
            // going to settings
            selectState.buttonId = 0
            selectState.buttonType = ButtonType.settingToggle
            selectState.clickState = 1
            state = 3
        } else if nextStateId == 6 {
            // going to tutorial
            // no selectState buttons yet
            state = 6
        } else if nextStateId == 5 {
            if prevButtonType == ButtonType.addNewPhrase {
                // if saving a phrase
                let newId = customList.count
                customList.append(CustomPhrase(id: newId, content: self.content))
                showSave = false
                content = ""
            } else if prevButtonType == ButtonType.exit{
                // if exiting
                showSave = false
                content = ""
            }
            selectState.buttonType = ButtonType.customPhrase
            selectState.buttonId = 0
            selectState.clickState = 0
            state = 5
        } else if nextStateId == 0 && prevState == 5 && lookLeft {
            // go to cover buttons
            state = 0
            selectState.buttonType = ButtonType.cover
            selectState.buttonId = 0
            selectState.clickState = 1
        } else if nextStateId == 7 {
            state = 7
            selectState.buttonType = ButtonType.calibration
            selectState.buttonId = 0
            selectState.clickState = 1
        }
    }
    
    private func lastState() {
        self.state = self.prevState
        if prevState == 0 {
            // going back to covers
            selectState.buttonType = ButtonType.cover
            selectState.buttonId = 0
        } else if prevState == 1 {
            // going back to rows
            selectState.buttonType = ButtonType.row
            selectState.buttonId = getFirstRow()
        } else if prevState == 2 {
            // going back to chars
            selectState.buttonType = ButtonType.char
            selectState.buttonId = getFirstChar()
        } else if prevState == 3 {
            // going back to settings
            selectState.buttonType = ButtonType.settingToggle
            selectState.buttonId = 0
        } else if prevState == 5 {
            // going back to custom phrases
            selectState.buttonType = ButtonType.customPhrase
            selectState.buttonId = 0
        } else if prevState == 6 {
            // set aside for later when tutorial uses selectState
        }
//        if selectState.buttonType == ButtonType.cover {
//            state = 0
//        } else if selectState.buttonType == ButtonType.row {
//            state = 1
//        } else if selectState.buttonType == ButtonType.char {
//            state = 2
//        }
    }
    
    private func scaleDim(isNo: Bool) -> CGFloat {
        if selectState.buttonType == ButtonType.confirm && selectState.isNo == isNo {
            return 80
        } else {
            return 60
        }
    }
    
    private func addBorder(isNo: Bool) -> CGFloat {
        if selectState.buttonType == ButtonType.confirm && selectState.isNo == isNo {
            return 3
        } else {
            return 0
        }
    }
    
    private func getFirstRow() -> Int {
        if rowState == 0 {
            return 0
        } else if rowState == 1 {
            return 6
        } else if rowState == 2 {
            return 10
        } else {
            return 3
        }
    }
    
    private func getFirstChar() -> Int {
        if charState == 0 {
            return 0
        } else if charState == 1 {
            return 10
        } else if charState == 2 {
            return 19
        } else if charState == 3 {
            return 52
        } else if charState == 4 {
            return 62
        } else if charState == 5 {
            return 72
        } else if charState == 6 {
            return 82
        } else if charState == 7 {
            return 87
        } else if charState == 8 {
            return 92
        } else if charState == 9 {
            return 26
        } else if charState == 10 {
            return 36
        } else {
            // charState == 11
            return 45
        }
    }
    
    private func charConfirmText() -> String {
        let character = CharRows.filter { row in
            row.id == selectState.buttonId
        }[0]
        return "Did you mean to select: \(character.character)?"
    }
    
    private func rowConfirmText() -> String {
        let rows = Rows.filter { row in
            row.id == selectState.buttonId
        }
        if !rows.isEmpty {
            let row = rows[0]
            return "Did you mean to select: \(row.image)?"
        }
        return ""
    }
    
    private func settingsConfirmText() -> String {
        return "Did you mean to open settings?"
    }
    
    private func tutorialConfirmText() -> String {
        return "Did you mean to open the tutorial"
    }
    
    private func coverConfirmText() -> String {
        var type: String
        if selectState.buttonId == 0 {
            type = "Uppercase Letters"
        } else if selectState.buttonId == 1 {
            type = "Symbols"
        } else if selectState.buttonId == 2 {
            type = "Numbers"
        } else if selectState.buttonId == 3 {
            type = "Lowercase Letters"
        } else {
            type = "ERROR WITH DETERMINING WHICH COVER WAS CLICKED"
        }
        return "Did you mean to select: \(type)?"
    }
    
    private func customPhraseText() -> String {
        return "Did you mean to select: \(customState)?"
    }
    
    private func addNewPhraseText() -> String {
        return "Would you like to save the phrase: \(content)?"
    }
    
}

struct ConfirmationPopup_Previews: PreviewProvider {
    static var tempSelect = selectedState(buttonType: ButtonType.cover, buttonId: 0, clickState: 0, isNo: false)
    
    static var previews: some View {
        ConfirmationPopup(state: .constant(1), rowState: .constant(1), charState: .constant(0), prevState: .constant(0), nextStateId: .constant(0), selectState: .constant(tempSelect), content: .constant(""), contentInd: .constant(0), queue: .constant([]), value: .constant(0), highlightBackspace: .constant(false), highlightCursor: .constant(false), playSound: .constant(true), customState: .constant(""), showSave: .constant(false), customList: .constant([]), prevButtonType: .constant(ButtonType.cover), lookLeft: .constant(false))
    }
}

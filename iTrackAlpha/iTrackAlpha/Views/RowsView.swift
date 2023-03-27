//
//  UpperRows.swift
//  Track
//
//  Created by Danielle Maraffino on 2/1/23.
//

import SwiftUI
import AVFoundation

struct RowsView: View {
    @State var audioPlayer: AVAudioPlayer!
    @Binding var state: Int
    @Binding var rowState: Int
    @Binding var charState: Int
    @Binding var prevState: Int
    @Binding var selectState: selectedState
    @Binding var highlightBackspace: Bool
    @Binding var queue: [Action]
    @Binding var value: Int
    @Binding var content: String
    @Binding var contentInd: Int
    @Binding var highlightCursor: Bool
    @Binding var playSound: Bool
    @Binding var showConfirmation: Bool
    @Binding var showSave: Bool
    @Binding var customList: [CustomPhrase]
    @Binding var nextStateId: Int
    @Binding var prevButtonType: ButtonType
    
    var rows: [Row] {
        Rows.filter { row in
            (row.RowType == rowState)
        }
    }
    
    var body: some View {
        VStack{
            Spacer()
            ForEach(rows) { row in
                Button(action: {
                    clickRow(row)
                }){
                    Text(row.image)
                        .frame(width: scaleDimWidth(buttonId: row.id), height: scaleDimHeight(buttonId: row.id))
                        .foregroundColor(.black)
                        .background(Color(red: 0.83, green: 0.83, blue: 0.83))
                        .border(.blue, width: addBorder(buttonId: row.id))
                        .font(.system(size: scaleFont(buttonId: row.id), weight: .semibold))
                        .cornerRadius(8)
                }
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
    
    private func registerBlink() {
        if selectState.buttonType == ButtonType.backspace {
            deleteChar()
        } else if selectState.buttonType == ButtonType.addNewPhrase {
            if playSound {
                makeSound()
            }
            savePhrase()
        } else if selectState.buttonType == ButtonType.exit {
            if playSound {
                makeSound()
            }
            exit()
        } else {
            // button type is row
            if showConfirmation {
                prevState = 1
                nextStateId = 2
                state = 4
                charState = rows[selectState.buttonId - getFirstRow()].CharType
                selectState.clickState = 1
                
                selectState.buttonType = ButtonType.confirm
                selectState.isNo = false
            } else {
                charState = rows[selectState.buttonId - getFirstRow()].CharType
                state = 2
                selectState.clickState = 1
                selectState.buttonType = ButtonType.char
                selectState.buttonId = getFirstChar()
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
        if curType == ButtonType.row && curId - getFirstRow() == 0 {
            if showSave {
                // go to add phrase
                highlightAddPhrase()
            } else {
                // go to backspace
                goToBackspace()
            }
        } else if curType == ButtonType.row && curId - getFirstRow() > 0 && curId - getFirstRow() < rows.count {
            // go to button(id-1)
            goToRow(id: curId-1)
        } else if curType == ButtonType.addNewPhrase || curType == ButtonType.exit {
            goToBackspace()
        }
    }
    
    private func goDown() {
        let curType = selectState.buttonType
        let curId = selectState.buttonId
        if curType == ButtonType.backspace {
            highlightBackspace = false
            if showSave {
                highlightAddPhrase()
            } else {
                // go to button(0)
                goToRow(id: getFirstRow())
            }
        } else if curType == ButtonType.row && curId - getFirstRow() < rows.count - 1 {
            // go to button(id + 1
            goToRow(id: curId + 1)
        } else if curType == ButtonType.cursor {
            highlightCursor = false
            if showSave {
                highlightExit()
            } else {
                goToRow(id: getFirstRow())
            }
        } else if curType == ButtonType.addNewPhrase || curType == ButtonType.exit{
            goToRow(id: getFirstRow())
        }
    }
    
    private func goLeft() {
        let curType = selectState.buttonType
        if curType == ButtonType.row || curType == ButtonType.exit {
            // go back to cover, without confirmation screen if set that way
            goToCovers()
        } else if curType == ButtonType.backspace {
            // go to cursor
            if content.count > 0 {
                highlightBackspace = false
                goToCursor()
            }
        } else if curType == ButtonType.cursor {
            moveCursorLeft()
        } else if curType == ButtonType.addNewPhrase {
            highlightExit()
        }
    }
    
    private func goRight() {
        let curType = selectState.buttonType
        if curType == ButtonType.cursor {
            if contentInd == content.count {
                highlightCursor = false
                goToBackspace()
            }
            else {
                moveCursorRight()
            }
        } else if curType == ButtonType.exit {
            highlightAddPhrase()
        }
    }
    
    private func goToCursor() {
        highlightCursor = true
        selectState.clickState = 1
        selectState.buttonId = 0
        selectState.buttonType = ButtonType.cursor
    }
    
    private func goToCovers() {
        selectState.clickState = 1
        selectState.buttonId = 0
        selectState.buttonType = ButtonType.cover
        state = 0
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
    
    private func goToBackspace() {
        selectState.clickState = 1
        selectState.buttonType = ButtonType.backspace
        selectState.buttonId = 0
        highlightBackspace = true
    }
    
    private func goToRow(id: Int) {
        selectState.clickState = 1
        selectState.buttonType = ButtonType.row
        selectState.buttonId = id
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
    
    private func scaleDimWidth(buttonId: Int) -> CGFloat {
        if selectState.buttonType == ButtonType.row && selectState.buttonId == buttonId && selectState.clickState == 1 {
            return 380
        } else {
            return 330
        }
    }
    
    private func scaleDimHeight (buttonId: Int) -> CGFloat {
        if selectState.buttonType == ButtonType.row && selectState.buttonId == buttonId && selectState.clickState == 1 {
            return 55
        } else {
            return 35
        }
    }
    
    private func addBorder (buttonId: Int) -> CGFloat {
        if selectState.buttonType == ButtonType.row && selectState.buttonId == buttonId && selectState.clickState == 1 {
            return 3.0
        } else {
            return 0
        }
    }
    
    private func scaleFont(buttonId: Int) -> CGFloat {
        if selectState.buttonType == ButtonType.row && selectState.buttonId == buttonId && selectState.clickState == 1 {
            return 30
        } else {
            return 20
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
    
    private func clickRow(_ row: Row){
        if selectState.clickState == 0 {
            selectState.clickState = 1
            selectState.buttonType = ButtonType.row
            selectState.buttonId = row.id
        } else if selectState.clickState == 1 {
            if(selectState.buttonId == row.id && selectState.buttonType == ButtonType.row) {
                if showConfirmation {
                    self.prevState = 1
                    self.nextStateId = 2
                    self.state = 4
                    self.charState = row.CharType
                    selectState.clickState = 0
                } else {
                    self.charState = row.CharType
                    state = 2
                    selectState.clickState = 1
                    selectState.buttonType = ButtonType.char
                    selectState.buttonId = getFirstChar()
                }
            } else {
                selectState.buttonType = ButtonType.row
                selectState.buttonId = row.id
            }
        }
        // tells backspace another button has been pushed
        highlightBackspace = false
        
    }
    
    private func highlightAddPhrase() {
        if content.isEmpty {
            highlightExit()
        } else {
            selectState.buttonId = 0
            selectState.buttonType = ButtonType.addNewPhrase
            selectState.clickState = 1
        }
    }
    
    private func savePhrase() {
        if (showConfirmation) {
            prevButtonType = ButtonType.addNewPhrase
            nextStateId = 5
            prevState = 0
            selectState.buttonId = 0
            selectState.buttonType = ButtonType.confirm
            selectState.isNo = false
            state = 4
        } else {
            let newId = customList.count
            customList.append(CustomPhrase(id: newId, content: self.content))
            showSave = false
            content = ""
            selectState.buttonType = ButtonType.customPhrase
            selectState.buttonId = 0
            state = 5
        }
    }
    
    private func highlightExit() {
        selectState.buttonId = 0
        selectState.buttonType = ButtonType.exit
        selectState.clickState = 1
    }
    
    private func exit() {
        showSave = false
        goToCustomPhrases()
    }
    
    private func goToCustomPhrases() {
        if showConfirmation {
            if selectState.buttonType == ButtonType.exit {
                prevButtonType = ButtonType.exit
            } else {
                prevButtonType = ButtonType.enterPhrases
            }
            nextStateId = 5
            prevState = 0
            selectState.buttonId = 0
            selectState.buttonType = ButtonType.confirm
            selectState.isNo = false
            state = 4
        } else {
            if selectState.buttonType == ButtonType.exit {
                content = ""
            }
            selectState.buttonType = ButtonType.customPhrase
            selectState.buttonId = 0
            selectState.clickState = 0
            state = 5
        }
    }
}

struct RowsView_Previews: PreviewProvider {
    static var tempSelect = selectedState(buttonType: ButtonType.cover, buttonId: 0, clickState: 0, isNo: false)
    
    static var previews: some View {
        RowsView(state: .constant(2), rowState: .constant(0), charState: .constant(0), prevState: .constant(1), selectState: .constant(tempSelect), highlightBackspace: .constant(false), queue: .constant([]), value: .constant(0), content: .constant(""), contentInd: .constant(0), highlightCursor: .constant(false), playSound: .constant(true), showConfirmation: .constant(true), showSave: .constant(false), customList: .constant([]), nextStateId: .constant(2), prevButtonType: .constant(ButtonType.cover))
    }
}

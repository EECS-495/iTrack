//
//  CharView.swift
//  Track
//
//  Created by Danielle Maraffino on 2/2/23.
//

import SwiftUI
import AVFoundation

struct CharView: View {
    @State var audioPlayer: AVAudioPlayer!
    @Binding var state: Int
    @Binding var rowState: Int
    @Binding var charState: Int
    @Binding var content: String
    @Binding var contentInd: Int
    @Binding var prevState: Int
    @Binding var selectState: selectedState
    @Binding var highlightBackspace: Bool
    @Binding var queue: [Action]
    @Binding var value: Int
    @Binding var highlightCursor: Bool
    @Binding var playSound: Bool
    @State var currentCharId = 0
    @Binding var showConfirmation: Bool
    @Binding var showSave: Bool
    @Binding var customList: [CustomPhrase]
    
    var charRows: [CharRow] {
        CharRows.filter { row in
            (row.CharType == charState)
        }
    }
    var body: some View {
        ScrollViewReader { spot in
            ScrollView{
                ForEach(charRows) { row in
                    Button(action: {clickChar(character: row)}){
                        Text(row.character)
                            .frame(width: scaleDim(row: row), height: scaleDim(row: row))
                            .font(.largeTitle)
                            .background(Color(red: 0.83, green: 0.83, blue: 0.83))
                            .foregroundColor(.black)
                            .border(.blue, width: addBorder(row: row))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 170)
                    .padding(.vertical, 10)
                    .id(row.id - getFirstChar())
                }
            }
            .onChange(of: currentCharId) { _ in
                spot.scrollTo(currentCharId, anchor: .center)
                print(currentCharId)
            }
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
        } else {
            if showConfirmation {
                prevState = 2
                state = 4
                selectState.clickState = 1
                selectState.buttonType = ButtonType.confirm
                selectState.isNo = false
            } else {
                // add text to content
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
        if curType == ButtonType.char && curId - getFirstChar() == 0 {
            if showSave {
                highlightAddPhrase()
            } else {
                // go to backspace
                goToBackspace()
            }
        } else if curType == ButtonType.char && curId - getFirstChar() > 0 && curId - getFirstChar() < charRows.count {
            // go to button(id-1)
            goToChar(id: curId-1)
            currentCharId = curId - getFirstChar() - 1
        } else if curType == ButtonType.addNewPhrase {
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
                goToChar(id: getFirstChar())
                currentCharId = 0
            }
        } else if curType == ButtonType.char && curId - getFirstChar() < charRows.count - 1 {
            // go to button(id + 1
            goToChar(id: curId + 1)
            currentCharId = curId - getFirstChar() + 1
        } else if curType == ButtonType.cursor {
            highlightCursor = false
            if showSave {
                highlightAddPhrase()
            } else {
                goToChar(id: getFirstChar())
                currentCharId = 0
            }
        } else if curType == ButtonType.addNewPhrase {
            goToChar(id: getFirstChar())
            currentCharId = 0
        }
    }
    
    private func goLeft() {
        let curType = selectState.buttonType
        if curType == ButtonType.char {
            // go to row view amybe with confirmation screen
        } else if curType == ButtonType.backspace {
            highlightBackspace = false
            goToCursor()
        } else if curType == ButtonType.cursor {
            moveCursorLeft()
        }
    }
    
    private func goRight() {
        let curType = selectState.buttonType
        if curType == ButtonType.cursor {
            if contentInd == content.count {
                highlightCursor = false
                goToBackspace()
            } else {
                moveCursorRight()
            }
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
    
    private func goToBackspace() {
        selectState.clickState = 1
        selectState.buttonType = ButtonType.backspace
        selectState.buttonId = 0
        highlightBackspace = true
    }
    
    private func goToChar(id: Int) {
        selectState.clickState = 1
        selectState.buttonType = ButtonType.char
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
    
    private func deleteChar() {
        if contentInd > 0 {
            makeSound()
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
    
    private func clickChar(character: CharRow) {
        if selectState.clickState == 0 {
            selectState.clickState = 1
            selectState.buttonType = ButtonType.char
            selectState.buttonId = character.id
        } else if selectState.clickState == 1 {
            if selectState.buttonType == ButtonType.char && selectState.buttonId == character.id {
                if showConfirmation {
                    prevState = 2
                    state = 4
                    selectState.clickState = 0
                } else {
                    // add text to content
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
                }
            } else {
                selectState.buttonId = character.id
                selectState.buttonType = ButtonType.char
            }
        }
        // tells backspace another button has been pushed
        highlightBackspace = false
    }
    
    private func scaleDim(row: CharRow) -> CGFloat {
        if selectState.clickState == 1 && selectState.buttonType == ButtonType.char && selectState.buttonId == row.id {
            return 100
        } else {
            return 60
        }
    }
    
    private func addBorder(row: CharRow) -> CGFloat {
        if selectState.clickState == 1 && selectState.buttonType == ButtonType.char && selectState.buttonId == row.id {
            return 3
        } else {
            return 0
        }
    }
    
    private func savePhrase() {
        let newId = customList.count
        customList.append(CustomPhrase(id: newId, content: self.content))
        showSave = false
        content = ""
        selectState.buttonType = ButtonType.customPhrase
        selectState.buttonId = 0
        state = 5
    }
    
    private func highlightAddPhrase() {
        selectState.buttonId = 0
        selectState.buttonType = ButtonType.addNewPhrase
        selectState.clickState = 1
    }
    
}

struct CharView_Previews: PreviewProvider {
    static var tempSelect = selectedState(buttonType: ButtonType.cover, buttonId: 0, clickState: 0, isNo: false)
    
    static var previews: some View {
        CharView(state: .constant(2), rowState: .constant(0), charState: .constant(0), content: .constant(""), contentInd: .constant(0), prevState: .constant(2), selectState: .constant(tempSelect), highlightBackspace: .constant(false), queue: .constant([]), value: .constant(0), highlightCursor: .constant(false), playSound: .constant(true), currentCharId: 0, showConfirmation: .constant(true), showSave: .constant(false), customList: .constant([]))
    }
}

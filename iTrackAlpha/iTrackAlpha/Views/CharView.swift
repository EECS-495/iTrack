//
//  CharView.swift
//  Track
//
//  Created by Danielle Maraffino on 2/2/23.
//

import SwiftUI

struct CharView: View {
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
    
    var charRows: [CharRow] {
        CharRows.filter { row in
            (row.CharType == charState)
        }
    }
    var body: some View {
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
        } else {
            prevState = 2
            state = 4
            selectState.clickState = 1
            selectState.buttonType = ButtonType.confirm
            selectState.isNo = false
        }
    }
    
    private func registerGaze(action: ActionType) {
        if action == ActionType.up {
            if selectState.buttonType == ButtonType.char && selectState.buttonId - getFirstChar() == 0 {
                // go to backspace
                goToBackspace()
            } else if selectState.buttonType == ButtonType.char && selectState.buttonId - getFirstChar() > 0 && selectState.buttonId - getFirstChar() < charRows.count {
                // go to button(id-1)
                goToChar(id: selectState.buttonId-1)
            }
        } else if action == ActionType.down {
            if selectState.buttonType == ButtonType.backspace {
                // go to button(0)
                goToChar(id: getFirstChar())
                highlightBackspace = false
            } else if selectState.buttonType == ButtonType.char && selectState.buttonId - getFirstChar() < charRows.count - 1 {
                // go to button(id + 1
                goToChar(id: selectState.buttonId + 1)
            }
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
        print(selectState.clickState)
        if selectState.clickState == 0 {
            selectState.clickState = 1
            selectState.buttonType = ButtonType.char
            selectState.buttonId = character.id
        } else if selectState.clickState == 1 {
            if selectState.buttonType == ButtonType.char && selectState.buttonId == character.id {
                prevState = 2
                state = 4
                selectState.clickState = 0
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
    
    
    
}

struct CharView_Previews: PreviewProvider {
    static var tempSelect = selectedState(buttonType: ButtonType.cover, buttonId: 0, clickState: 0, isNo: false)
    
    static var previews: some View {
        CharView(state: .constant(2), rowState: .constant(0), charState: .constant(0), content: .constant(""), contentInd: .constant(0), prevState: .constant(2), selectState: .constant(tempSelect), highlightBackspace: .constant(false), queue: .constant([]), value: .constant(0))
    }
}


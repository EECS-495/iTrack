//
//  ConfirmationPopup.swift
//  Track
//
//  Created by Amanda Beger on 2/7/23.
//

import SwiftUI

struct ConfirmationPopup: View {
    @Binding var state: Int
    @Binding var rowState: Int
    @Binding var charState: Int
    @Binding var prevState: Int
    @Binding var selectState: selectedState
    @Binding var content: String
    @Binding var contentInd: Int
    @Binding var queue: [Action]
    @Binding var value: Int
    @Binding var highlightBackspace: Bool
        
    
    var body: some View {
        
        VStack {
            
            if prevState == 0 {
                Text(coverConfirmText())
                    .foregroundColor(.black)
            } else if prevState == 1 {
                Text(rowConfirmText())
                    .foregroundColor(.black)
            } else if prevState == 2 {
                Text(charConfirmText())
                    .foregroundColor(.black)
            }
            
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
            if selectState.buttonType == ButtonType.backspace {
                // go to yes
                highlightBackspace = false
                goToYes()
            }
        } else if action == ActionType.right {
            if selectState.buttonType == ButtonType.confirm && !selectState.isNo {
                // go to no
                goToNo()
            }
        } else if action == ActionType.left {
            if selectState.buttonType == ButtonType.confirm && selectState.isNo {
                // go to yes
                goToYes()
            }
        }
    }
    
    private func goToBackspace() {
        selectState.clickState = 1
        selectState.buttonType = ButtonType.backspace
        highlightBackspace = true
    }
    
    private func goToYes() {
        print("in yes")
        selectState.clickState = 1
        selectState.buttonType = ButtonType.confirm
        selectState.isNo = false
    }
    
    private func goToNo() {
        print("in no")
        selectState.clickState = 1
        selectState.buttonType = ButtonType.confirm
        selectState.isNo = true
    }
    
    private func nextState() {
        if prevState == 0 {
            state = 1
            selectState.clickState = 1
            selectState.buttonType = ButtonType.row
            selectState.buttonId = getFirstRow()
            print(selectState.buttonId)
        } else if prevState == 1{
            state = 2
            selectState.clickState = 1
            selectState.buttonType = ButtonType.char
            selectState.buttonId = getFirstChar()
        } else if prevState == 2 {
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
    
    private func lastState() {
        self.state = self.prevState
        if prevState == 0 {
            selectState.buttonType = ButtonType.cover
            selectState.buttonId = 0
        } else if prevState == 1 {
            selectState.buttonType = ButtonType.row
            selectState.buttonId = getFirstRow()
        } else if prevState == 2 {
            selectState.buttonType = ButtonType.char
            selectState.buttonId = getFirstChar()
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
        return "Did you mean to select: \(character.character)"
    }
    
    private func rowConfirmText() -> String {
        let rows = Rows.filter { row in
            row.id == selectState.buttonId
        }
        print(rows)
        if !rows.isEmpty {
            let row = rows[0]
            return "Did you mean to select: \(row.image)"
        }
        return ""
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
        return "Did you mean to select: \(type)"
    }
}

struct ConfirmationPopup_Previews: PreviewProvider {
    static var tempSelect = selectedState(buttonType: ButtonType.cover, buttonId: 0, clickState: 0, isNo: false)
    
    static var previews: some View {
        ConfirmationPopup(state: .constant(1), rowState: .constant(1), charState: .constant(0), prevState: .constant(0), selectState: .constant(tempSelect), content: .constant(""), contentInd: .constant(0), queue: .constant([]), value: .constant(0), highlightBackspace: .constant(false))
    }
}

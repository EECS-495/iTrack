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
        
    
    var body: some View {
        
        VStack {
            
            if selectState.buttonType == ButtonType.cover {
                Text(coverConfirmText())
            } else if selectState.buttonType == ButtonType.row {
                Text(rowConfirmText())
            } else if selectState.buttonType == ButtonType.char {
                Text(charConfirmText())
            }
            
            HStack {
                Button(action: nextState) {
                    Text("Yes")
                        .frame(width: 60, height: 60)
                        .foregroundColor(.black)
                        .background(CustomColor.lightgray)
                        .cornerRadius(8)
                }
                Button(action: lastState) {
                    Text("No")
                        .frame(width: 60, height: 60)
                        .foregroundColor(.black)
                        .background(CustomColor.lightgray)
                        .cornerRadius(8)
                }
            }
        }
    }
    
    private func nextState() {
        if selectState.buttonType == ButtonType.cover {
            state = 1
        } else if selectState.buttonType == ButtonType.row{
            state = 2
        } else if selectState.buttonType == ButtonType.char {
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
        }
    }
    
    private func lastState() {
        // self.state = self.prevState
        if selectState.buttonType == ButtonType.cover {
            state = 0
        } else if selectState.buttonType == ButtonType.row {
            state = 1
        } else if selectState.buttonType == ButtonType.char {
            state = 2
        }
    }
    
    private func charConfirmText() -> String {
        let character = CharRows.filter { row in
            row.id == selectState.buttonId
        }[0]
        return "Did you mean to select: \(character.character)"
    }
    
    private func rowConfirmText() -> String {
        let row = Rows.filter { row in
            row.id == selectState.buttonId
        }[0]
        return "Did you mean to select: \(row.image)"
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
    static var tempSelect = selectedState(buttonType: ButtonType.cover, buttonId: 0, clickState: 0)
    
    static var previews: some View {
        ConfirmationPopup(state: .constant(1), rowState: .constant(1), charState: .constant(0), prevState: .constant(0), selectState: .constant(tempSelect), content: .constant(""), contentInd: .constant(0))
    }
}

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
        } else {
            // button type is row
            if showConfirmation {
                prevState = 1
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
            // go to backspace
            goToBackspace()
        } else if curType == ButtonType.row && curId - getFirstRow() > 0 && curId - getFirstRow() < rows.count {
            // go to button(id-1)
            goToRow(id: curId-1)
        }
    }
    
    private func goDown() {
        let curType = selectState.buttonType
        let curId = selectState.buttonId
        if curType == ButtonType.backspace {
            // go to button(0)
            goToRow(id: getFirstRow())
            highlightBackspace = false
        } else if curType == ButtonType.row && curId - getFirstRow() < rows.count - 1 {
            // go to button(id + 1
            goToRow(id: curId + 1)
        } else if curType == ButtonType.cursor {
            highlightCursor = false
            goToRow(id: getFirstRow())
        }
    }
    
    private func goLeft() {
        let curType = selectState.buttonType
        if curType == ButtonType.row {
            // go back to cover, without confirmation screen if set that way
        } else if curType == ButtonType.backspace {
            // go to cursor
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
            }
            else {
                moveCursorRight()
            }
        }
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
    
}

struct RowsView_Previews: PreviewProvider {
    static var tempSelect = selectedState(buttonType: ButtonType.cover, buttonId: 0, clickState: 0, isNo: false)
    
    static var previews: some View {
        RowsView(state: .constant(2), rowState: .constant(0), charState: .constant(0), prevState: .constant(1), selectState: .constant(tempSelect), highlightBackspace: .constant(false), queue: .constant([]), value: .constant(0), content: .constant(""), contentInd: .constant(0), highlightCursor: .constant(false), playSound: .constant(true), showConfirmation: .constant(true))
    }
}

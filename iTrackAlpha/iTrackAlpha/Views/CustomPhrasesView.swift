//
//  CustomPhrasesView.swift
//  iTrackAlpha
//
//  Created by Amanda Beger on 3/15/23.
//

import SwiftUI
import AVFoundation

struct CustomPhrasesView: View {
    @Binding var customList: [CustomPhrase]
    @Binding var content: String
    @Binding var contentInd: Int
    @Binding var state: Int
    @Binding var showSave: Bool
    @Binding var queue: [Action]
    @Binding var value: Int
    @Binding var selectState: selectedState
    @Binding var highlightBackspace: Bool
    @Binding var highlightCursor: Bool
    @Binding var prevState: Int
    @Binding var showConfirmation: Bool
    @Binding var customState: String
    @Binding var nextStateId: Int
    @State var curId: Int = 0
    @State var onAddPhrase: Bool = false
    @State var audioPlayer: AVAudioPlayer!
    
    
    var body: some View {
        VStack {
            List(customList) { customPhrase in
                Button(action: {
                    clickContent(customPhrase)
                }) {
                    Text(customPhrase.content)
                }
                .padding()
                .border(.blue, width: addBorder(customPhrase))
            }
            
            Button(action: {addPhrase()}) {
                Text("Add New Custom Text")
                    .frame(width: widthDim(), height: heightDim())
                    .foregroundColor(.black)
                    .background(Color(red: 0.83, green: 0.83, blue: 0.83))
                    .border(.blue, width: addNewBorder())
                    .cornerRadius(8)
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
                            
    private func addNewBorder() -> CGFloat {
        if onAddPhrase {
            return 3.0
        } else {
            return 0.0
        }
    }
    
    private func widthDim() -> CGFloat {
        if onAddPhrase {
            return 160
        } else {
            return 140
        }
    }
    
    private func heightDim() -> CGFloat {
        if onAddPhrase {
            return 65
        } else {
            return 45
        }
    }
    
    private func clickContent(_ customPhrase: CustomPhrase) {
        if showConfirmation {
            goToNextState()
        } else {
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
            content = content1 + customPhrase.content + content2
            contentInd = contentInd + customPhrase.content.count
            goToNextState()
        }
    }
    
    private func addPhrase() {
        showSave = true
        goToNextState()
    }
    
    private func goToNextState() {
        if showConfirmation && !showSave {
            state = 4
            selectState.clickState = 1
            selectState.buttonType = ButtonType.confirm
            selectState.isNo = false
            customState = customList[curId].content
            nextStateId = 0
            prevState = 5
        } else {
            selectState.clickState = 1
            selectState.buttonType = ButtonType.cover
            selectState.buttonId = 0
            state = 0
        }
    }
    
    private func addBorder(_ customPhrase: CustomPhrase) -> CGFloat {
        if customPhrase.id == curId && selectState.buttonType == ButtonType.customPhrase {
            return 3.0
        } else {
            return 0
        }
    }
    
    private func registerBlink() {
        if selectState.buttonType == ButtonType.customPhrase {
            clickContent(customList[curId])
        } else if onAddPhrase {
            onAddPhrase = false
            addPhrase()
        } else if selectState.buttonType == ButtonType.backspace {
            deleteChar()
        }
    }
    
    private func registerGaze(action: ActionType) {
        if action == ActionType.up {
            goUp()
        } else if action == ActionType.down {
            goDown()
        } else if action == ActionType.right {
            goRight()
        } else if action == ActionType.left {
            goLeft()
        }
    }
    
    private func goUp() {
        if selectState.buttonType == ButtonType.customPhrase {
            if curId == 0 {
                goToBackspace()
            } else {
                curId -= 1
                selectState.clickState = 1
                selectState.buttonType = ButtonType.customPhrase
                selectState.buttonId = 0
            }
        } else if onAddPhrase {
            curId = customList.count - 1
            selectState.clickState = 1
            selectState.buttonType = ButtonType.customPhrase
            selectState.buttonId = 0
            onAddPhrase = false
        }
    }
    
    private func goDown() {
        if selectState.buttonType == ButtonType.cursor || selectState.buttonType == ButtonType.backspace {
            highlightBackspace = false
            highlightCursor = false
            if showSave {
                highlightAddPhrase()
            } else {
                selectState.buttonType = ButtonType.customPhrase
                selectState.buttonId = 0
                selectState.clickState = 1
                curId = 0
            }
        } else if curId == customList.count - 1 && selectState.buttonType == ButtonType.customPhrase {
            onAddPhrase = true
            selectState.buttonType = ButtonType.addNewPhrase
        } else if selectState.buttonType == ButtonType.customPhrase {
            curId += 1
            selectState.clickState = 1
            selectState.buttonType = ButtonType.customPhrase
            selectState.buttonId = 0
        }
    }
    
    private func goRight() {
        if selectState.buttonType == ButtonType.cursor {
            if contentInd == content.count {
                highlightCursor = false
                goToBackspace()
            } else {
                moveCursorRight()
            }
        }
    }
    
    private func goLeft() {
        let curType = selectState.buttonType
        if curType == ButtonType.backspace {
            highlightBackspace = false
            goToCursor()
        } else if curType == ButtonType.cursor {
            moveCursorLeft()
        } else if curType == ButtonType.customPhrase || onAddPhrase{
            goToNextState()
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
    
    private func highlightAddPhrase() {
        selectState.buttonId = 0
        selectState.buttonType = ButtonType.addNewPhrase
        selectState.clickState = 1
    }
}

struct CustomPhrasesView_Previews: PreviewProvider {
    static var tempCustom = CustomPhrase(id: 0, content: "")
    static var tempSelect = selectedState(buttonType: ButtonType.customPhrase, buttonId: 0, clickState: 0, isNo: false)
    
    static var previews: some View {
        CustomPhrasesView(customList: .constant([]), content: .constant(""), contentInd: .constant(0), state: .constant(5), showSave: .constant(false), queue: .constant([]), value: .constant(0), selectState: .constant(tempSelect), highlightBackspace: .constant(false), highlightCursor: .constant(false), prevState: .constant(5), showConfirmation: .constant(false), customState: .constant(""), nextStateId: .constant(0))
    }
}


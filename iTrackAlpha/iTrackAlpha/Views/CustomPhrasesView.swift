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
    @Binding var prevButtonType: ButtonType
    @Binding var lookLeft: Bool
    @Binding var predictedWords: [String]
    @State var curId: Int = 0
    @State var onAddPhrase: Bool = false
    @State var audioPlayer: AVAudioPlayer!
    @State var isDelete: Bool = false
    
    
    var body: some View {
        VStack {
            List(customList) { customPhrase in
                HStack {
                    Button(action: {
                        clickContent(customPhrase)
                    }) {
                        Text(customPhrase.content)
                    }
                    .padding()
                    .border(.blue, width: addBorder(customPhrase))
                    .foregroundColor(.black)
                    Spacer()
                    Button(action: {
                        delete(customPhrase)
                    }) {
                        Text("Delete")
                    }
                    .padding()
                    .border(.blue, width: addDeleteBorder(customPhrase))
                    .foregroundColor(.black)
                }
            }
            if !showSave {
                Button(action: {addPhrase()}) {
                    Text("Add New Custom Text")
                        .frame(width: widthDim(), height: heightDim())
                        .foregroundColor(.black)
                        .background(Color(red: 0.83, green: 0.83, blue: 0.83))
                        .border(.blue, width: addNewBorder())
                        .cornerRadius(8)
                }
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
            
            updatePredictedWords()
        }
    }
    
    private func delete(_ customPhrase: CustomPhrase) {
        customList.remove(at: customPhrase.id)
        if(customList.isEmpty) {
            onAddPhrase = true
        } else {
            // re-set all ids
            for i in 0...(customList.count - 1) {
                customList[i].id = i
            }
            
            if curId == customList.count {
                curId = curId - 1
            }
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
            lookLeft = false
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
        if customPhrase.id == curId && selectState.buttonType == ButtonType.customPhrase && !onAddPhrase && !isDelete{
            return 3.0
        } else {
            return 0
        }
    }
    
    private func addDeleteBorder(_ customPhrase: CustomPhrase) -> CGFloat {
        if customPhrase.id == curId && selectState.buttonType == ButtonType.customPhrase && !onAddPhrase && isDelete {
            return 3.0
        } else {
            return 0
        }
    }
    
    private func registerBlink() {
        if selectState.buttonType == ButtonType.customPhrase && !onAddPhrase && !isDelete {
            clickContent(customList[curId])
        } else if onAddPhrase {
            onAddPhrase = false
            addPhrase()
        } else if selectState.buttonType == ButtonType.backspace {
            deleteChar()
        } else if selectState.buttonType == ButtonType.addNewPhrase {
            savePhrase()
        } else if selectState.buttonType == ButtonType.exit {
            exit()
        } else if selectState.buttonType == ButtonType.customPhrase && !onAddPhrase && isDelete {
            makeSound()
            delete(customList[curId])
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
        if selectState.buttonType == ButtonType.customPhrase && !onAddPhrase {
            if curId == 0 {
                isDelete = false
                if showSave {
                    highlightAddPhrase()
                } else {
                    goToBackspace()
                }
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
        } else if selectState.buttonType == ButtonType.addNewPhrase || selectState.buttonType == ButtonType.exit {
            goToBackspace()
        }
    }
    
    private func goDown() {
        if (selectState.buttonType == ButtonType.cursor || selectState.buttonType == ButtonType.backspace) && !onAddPhrase {
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
        } else if (curId == customList.count - 1 && selectState.buttonType == ButtonType.customPhrase) && !onAddPhrase {
            isDelete = false
            onAddPhrase = true
        } else if selectState.buttonType == ButtonType.customPhrase {
            curId += 1
            selectState.clickState = 1
            selectState.buttonType = ButtonType.customPhrase
            selectState.buttonId = 0
        } else if selectState.buttonType == ButtonType.addNewPhrase || selectState.buttonType == ButtonType.exit {
            selectState.buttonType = ButtonType.customPhrase
            selectState.buttonId = 0
            selectState.clickState = 1
            curId = 0
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
        } else if selectState.buttonType == ButtonType.exit {
            highlightAddPhrase()
        } else if selectState.buttonType == ButtonType.customPhrase {
            isDelete = true
        }
    }
    
    private func goLeft() {
        let curType = selectState.buttonType
        if curType == ButtonType.backspace {
            highlightBackspace = false
            goToCursor()
        } else if curType == ButtonType.cursor {
            moveCursorLeft()
        } else if isDelete {
            isDelete = false
        } else if curType == ButtonType.customPhrase || onAddPhrase || curType == ButtonType.exit {
            goToCover()
        } else if curType == ButtonType.addNewPhrase {
            highlightExit()
        }
    }
    
    private func goToCover() {
        if showConfirmation {
            nextStateId = 0
            prevState = 5
            lookLeft = true
            selectState.buttonId = 0
            selectState.buttonType = ButtonType.confirm
            selectState.isNo = false
            state = 4
        } else {
            selectState.buttonType = ButtonType.cover
            selectState.buttonId = 0
            state = 0
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
            
            updatePredictedWords()
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
        if content.isEmpty {
            highlightExit()
        } else {
            selectState.buttonId = 0
            selectState.buttonType = ButtonType.addNewPhrase
            selectState.clickState = 1
        }
    }
    
    private func highlightExit() {
        selectState.buttonId = 0
        selectState.buttonType = ButtonType.exit
        selectState.clickState = 1
    }
    
    private func exit() {
        if showConfirmation {
            prevButtonType = ButtonType.exit
            nextStateId = 5
            prevState = 5
            selectState.buttonId = 0
            selectState.buttonType = ButtonType.confirm
            selectState.isNo = false
            state = 4
        } else {
            showSave = false
            content = ""
            selectState.buttonType = ButtonType.customPhrase
            selectState.buttonId = 0
            curId = 0
        }
    }
    
    private func savePhrase() {
        if (showConfirmation) {
            prevButtonType = ButtonType.addNewPhrase
            nextStateId = 5
            prevState = 5
            lookLeft = false
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
    
    private func updatePredictedWords() {

        let textChecker = UITextChecker()

        print("update_predict_word_called")
        let cursorIndex = content.index(content.startIndex, offsetBy: contentInd)

        

        let lastSpaceOrNewline = content[..<cursorIndex].rangeOfCharacter(from: .whitespacesAndNewlines, options: .backwards)?.upperBound

        let lastWordStartIndex = lastSpaceOrNewline ?? content.startIndex

        let lastWordRange = NSRange(lastWordStartIndex..<cursorIndex, in: content)

        

        if let completions = textChecker.completions(forPartialWordRange: lastWordRange, in: content, language: "en") {

            predictedWords = Array(completions.prefix(3))

            print("predict words:", predictedWords)

        } else {

            predictedWords = []

            print("predict words: nothing")

        }

    }
    
    
}

struct CustomPhrasesView_Previews: PreviewProvider {
    static var tempCustom = CustomPhrase(id: 0, content: "")
    static var tempSelect = selectedState(buttonType: ButtonType.customPhrase, buttonId: 0, clickState: 0, isNo: false)
    
    static var previews: some View {
        CustomPhrasesView(customList: .constant([]), content: .constant(""), contentInd: .constant(0), state: .constant(5), showSave: .constant(false), queue: .constant([]), value: .constant(0), selectState: .constant(tempSelect), highlightBackspace: .constant(false), highlightCursor: .constant(false), prevState: .constant(5), showConfirmation: .constant(false), customState: .constant(""), nextStateId: .constant(0), prevButtonType: .constant(ButtonType.cover), lookLeft: .constant(false), predictedWords: .constant(["a", "b", "c"]))
    }
}


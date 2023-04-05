//
//  TextButton.swift
//  Track
//
//  Created by Danielle Maraffino on 1/31/23.
//

import SwiftUI
import AVFoundation

struct CoverButtons: View {
    
    @State var tutorialTimer = Timer.publish(every: 0, on: .main, in: .common).autoconnect()
    @State var audioPlayer: AVAudioPlayer!
    @Binding var state: Int
    @Binding var rowState: Int
    @Binding var content: String
    @Binding var contentInd: Int
    @Binding var prevState: Int
    @Binding var selectState: selectedState
    @Binding var highlightBackspace: Bool
    @Binding var queue: [Action]
    @Binding var value: Int
    @Binding var showHelpButton: Bool
    @Binding var highlightCursor: Bool
    @Binding var playSound: Bool
    @Binding var showConfirmation: Bool
    @Binding var showSave: Bool
    @Binding var customList: [CustomPhrase]
    @Binding var nextStateId: Int
    @Binding var prevButtonType: ButtonType
        
    var body: some View {
        VStack{
            Spacer()
            Button(action: {toNextState(buttonID: 0)}){
                Image("uppercover")
                    .resizable()
                    .border(.blue, width: addBorder(buttonType: ButtonType.cover, buttonId: 0))
                    .frame(width: scaleDim(buttonType: ButtonType.cover, buttonId: 0), height: scaleDim(buttonType: ButtonType.cover, buttonId: 0))
                    .cornerRadius(8)
            }
            
            HStack{
                Button(action: {toNextState(buttonID: 1)}){
                    Image("symbolscover")
                        .resizable()
                        .border(.blue, width: addBorder(buttonType: ButtonType.cover, buttonId: 1))
                        .frame(width: scaleDim(buttonType: ButtonType.cover, buttonId: 1), height: scaleDim(buttonType: ButtonType.cover, buttonId: 1))
                        .cornerRadius(8)
                    
                }
                
                Spacer()
                Button(action: addSpace){
                    Text("Space")
                        .frame(width: scaleDim(buttonType: ButtonType.space, buttonId: 0), height: scaleDim(buttonType: ButtonType.space, buttonId: 0))
                        .foregroundColor(.black)
                        .background(Color(red: 0.83, green: 0.83, blue: 0.83))
                        .border(.blue, width: addBorder(buttonType: ButtonType.space, buttonId: 0))
                        .cornerRadius(8)
                }
                Spacer()
                Button(action: {toNextState(buttonID: 2)}){
                    Image("numberscover")
                        .resizable()
                        .border(.blue, width: addBorder(buttonType: ButtonType.cover, buttonId: 2))
                        .frame(width: scaleDim(buttonType: ButtonType.cover, buttonId: 2), height: scaleDim(buttonType: ButtonType.cover, buttonId: 2))
                        .cornerRadius(8)
                }
            }
            Button(action: {toNextState(buttonID: 3)}){
                Image("lowercover")
                    .resizable()
                    .border(.blue, width: addBorder(buttonType: ButtonType.cover, buttonId: 3))
                    .frame(width: scaleDim(buttonType: ButtonType.cover, buttonId: 3), height: scaleDim(buttonType: ButtonType.cover, buttonId: 3))
                    .cornerRadius(8)
            }
            Spacer()
            Button(action: {goToCustomPhrases()}){
                Text("Custom Phrases")
                    .frame(width: widthDim(), height: heightDim())
                    .foregroundColor(.black)
                    .background(Color(red: 0.83, green: 0.83, blue: 0.83))
                    .border(.blue, width: addBorder(buttonType: ButtonType.enterPhrases, buttonId: 0))
                    .cornerRadius(8)
            }
            Spacer()
            HStack{
                Button(action: {tutorial()}) {
                    Text("?")
                        .foregroundColor(isTutorialHighlighted() ? .blue : .black)
                        .font(.system(size: isTutorialHighlighted() ? 30 : 20, weight: isTutorialHighlighted() ? .medium : .light))
                        .overlay(
                            Circle()
                                .stroke(isTutorialHighlighted() ? Color.blue : Color.black, lineWidth: isTutorialHighlighted() ? 2.0 : 1.0)
                                .frame(width: isTutorialHighlighted() ? 30: 20, height: isTutorialHighlighted() ? 30: 20)
                        )
                }
                .scaleEffect(showHelpButton ? 1 : 0.001)
                .padding()
                .onReceive(tutorialTimer) {_ in
                    if(state == 0){
                        showHelpButton = true
                    }
                }
                Spacer()
                Button(action: {goToSettings()}){
                   Image(getSettingsImage())
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                .padding()
            }
        }
        .padding()
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
    
    private func widthDim() -> CGFloat {
        if selectState.buttonType == ButtonType.enterPhrases {
            return 160
        } else {
            return 140
        }
    }
    
    private func heightDim() -> CGFloat {
        if selectState.buttonType == ButtonType.enterPhrases {
            return 65
        } else {
            return 45
        }
    }
    
    private func highlightSettings() {
        selectState.buttonId = 0
        selectState.buttonType = ButtonType.enterSettings
    }
    
    private func highlightCustomPhrase() {
        selectState.buttonId = 0
        selectState.buttonType = ButtonType.enterPhrases
        selectState.clickState = 1
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
        // showSave = false
        goToCustomPhrases()
    }
    
    private func goToSettings() {
        // change selectState
        // change actual state
        if showConfirmation {
            state = 4
            prevState = 0
            nextStateId = 3
            selectState.buttonId = 0
            selectState.buttonType = ButtonType.confirm
            selectState.isNo = false
        } else {
            selectState.buttonType = ButtonType.settingToggle
            selectState.buttonId = 0
            state = 3
        }
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
                showSave = false
            }
            selectState.buttonType = ButtonType.customPhrase
            selectState.buttonId = 0
            selectState.clickState = 0
            state = 5
        }
    }
    
    private func isTutorialHighlighted() -> Bool {
        // exists to leave room to expand later if we need to check more conditions than just selectState button type to check if we should highlight the tutorial button
        return selectState.buttonType == ButtonType.tutorial
    }
    
    private func tutorial() {
        if showConfirmation {
            state = 4
            selectState.buttonId = 0
            selectState.buttonType = ButtonType.confirm
            selectState.isNo = false
            prevState = 0
            nextStateId = 6
        } else {
            state = 6
            // change selectState here if you add buttons within the tutorial later that require eye tracking
        }
    }
    
    private func getSettingsImage() -> String {
        if selectState.buttonType == ButtonType.enterSettings {
            return "blueGear"
        } else {
            return "greyGear"
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
        let curType = selectState.buttonType
        let curId = selectState.buttonId
        if curType == ButtonType.cover {
            if curId == 0 {
                if showSave {
                    highlightAddPhrase()
                } else {
                    goToBackspace()
                }
            } else if curId == 1 || curId == 2 {
                // go to upper
                goToCover(buttonId: 0)
            } else if curId == 3 {
                // go to space
                goToSpace()
            }
        } else if curType == ButtonType.space {
            // go to upper
            goToCover(buttonId: 0)
        } else if curType == ButtonType.enterSettings {
            highlightCustomPhrase()
        } else if curType == ButtonType.enterPhrases {
            goToCover(buttonId: 3)
        } else if curType == ButtonType.tutorial {
            highlightCustomPhrase()
        } else if curType == ButtonType.addNewPhrase || curType == ButtonType.exit {
            goToBackspace()
        }
    }
    
    private func goDown() {
        let curType = selectState.buttonType
        let curId = selectState.buttonId
        if curType == ButtonType.cover {
            if curId == 0 {
                // go to space
                goToSpace()
            } else if curId == 1 || curId == 2 {
                // go to lower
                goToCover(buttonId: 3)
            } else if curId == 3 {
                // go to settings cover
                // highlightSettings()
                highlightCustomPhrase()
            }
        } else if curType == ButtonType.space {
            // go to lower
            goToCover(buttonId: 3)
        } else if curType == ButtonType.backspace {
            //go to upper
            highlightBackspace = false
            if showSave {
                highlightAddPhrase()
            } else {
                goToCover(buttonId: 0)
            }
        } else if curType == ButtonType.cursor {
            // go to upper
            highlightCursor = false
            if showSave {
                highlightExit()
            } else {
                goToCover(buttonId: 0)
            }
        } else if curType == ButtonType.enterPhrases {
            highlightSettings()
        } else if curType == ButtonType.addNewPhrase || curType == ButtonType.exit {
            highlightCursor = false
            goToCover(buttonId: 0)
        }
    }
    
    private func goRight() {
        let curType = selectState.buttonType
        let curId = selectState.buttonId
        if curType == ButtonType.cover {
            if curId == 1 {
                // go to space
                goToSpace()
            } else if curId == 0 || curId == 3 {
                // go to numbers
                goToCover(buttonId: 2)
            }
        } else if curType == ButtonType.space {
            // go to numbers
            goToCover(buttonId: 2)
        } else if curType == ButtonType.cursor {
            // if cursorInd is at end of word, move to backspace, highlight cursor = false
            // call cursorRight
            if contentInd == content.count {
                goToBackspace()
                highlightCursor = false
            }
            else {
                moveCursorRight()
            }
        } else if curType == ButtonType.tutorial {
            goToSettings()
        } else if curType == ButtonType.exit {
            highlightAddPhrase()
        }
    }
    
    private func goLeft() {
        let curType = selectState.buttonType
        let curId = selectState.buttonId
        if curType == ButtonType.cover {
            if curId == 2 {
                // go to space
                goToSpace()
            } else if curId == 0 || curId == 3 {
                // go to symbols
                goToCover(buttonId: 1)
            }
        } else if curType == ButtonType.space {
            // go to symbols
            goToCover(buttonId: 1)
        } else if curType == ButtonType.backspace {
            // go to cursor
            if content.count > 0 {
                highlightBackspace = false
                goToCursor()
            }
        } else if curType == ButtonType.cursor {
            // call cursorLeft
            moveCursorLeft()
        } else if curType == ButtonType.enterSettings {
            // go to enter tutorial button
            if showHelpButton {
                highlightTutorial()
            }
        } else if curType == ButtonType.addNewPhrase {
            highlightExit()
        }
    }
    
    private func highlightTutorial() {
        selectState.buttonType = ButtonType.tutorial
        selectState.buttonId = 0
    }
    
    private func goToCursor() {
        selectState.clickState = 1
        selectState.buttonType = ButtonType.cursor
        selectState.buttonId = 0
        highlightCursor = true
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
    
    private func goToSpace() {
        selectState.clickState = 1
        selectState.buttonType = ButtonType.space
        selectState.buttonId = 0
    }
    
    private func goToCover(buttonId: Int) {
        selectState.clickState = 1
        selectState.buttonType = ButtonType.cover
        selectState.buttonId = buttonId
    }
    
    private func goToBackspace() {
        selectState.clickState = 1
        selectState.buttonType = ButtonType.backspace
        selectState.buttonId = 0
        highlightBackspace = true
    }
    
    
    private func registerBlink() {
        makeSound()
        if selectState.buttonType == ButtonType.space {
            if playSound {
                makeSound()
            }
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
            content = content1 + " " + content2
            contentInd = contentInd + 1
        } else if selectState.buttonType == ButtonType.backspace {
            deleteChar()
        } else if selectState.buttonType == ButtonType.enterSettings {
            // TO DO - later add in confirmation screen step??
            if playSound {
                makeSound()
            }
            if showConfirmation {
                state = 4
                showHelpButton = false
                selectState.clickState = 1
                selectState.buttonType = ButtonType.confirm
                selectState.isNo = false
                prevState = 0
                nextStateId = 3
                
            } else {
                goToSettings()
            }
        } else if selectState.buttonType == ButtonType.enterPhrases {
            showHelpButton = false
            if playSound {
                makeSound()
            }
            goToCustomPhrases()
        } else if selectState.buttonType == ButtonType.addNewPhrase {
            showHelpButton = false
            if playSound {
                makeSound()
            }
            savePhrase()
        } else if selectState.buttonType == ButtonType.tutorial {
            showHelpButton = false
            tutorial()
        } else if selectState.buttonType == ButtonType.cover {
            // cover was selected
            if showConfirmation {
                state = 4
                showHelpButton = false
                rowState = selectState.buttonId
                selectState.clickState = 1
                selectState.buttonType = ButtonType.confirm
                selectState.isNo = false
                prevState = 0
                nextStateId = 1
            } else {
                showHelpButton = false
                rowState = selectState.buttonId
                state = 1
                selectState.clickState = 1
                selectState.buttonType = ButtonType.row
                selectState.buttonId = getFirstRow()
            }
        } else if selectState.buttonType == ButtonType.exit {
            if playSound {
                makeSound()
            }
            exit()
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
    
    private func addBorder(buttonType: ButtonType, buttonId: Int) -> CGFloat {
        if selectState.buttonType == buttonType && selectState.buttonId == buttonId && selectState.clickState == 1{
            return 3.0
        } else {
            return 0
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
    
    private func scaleDim(buttonType: ButtonType, buttonId: Int) -> CGFloat {
        if selectState.buttonType == buttonType && selectState.buttonId == buttonId && selectState.clickState == 1{
            if buttonType == ButtonType.space {
                return 80.0
            } else {
                return 110.0
            }
        } else {
            if buttonType == ButtonType.space {
                return 60.0
            } else {
                return 90.0
            }
        }
    }
    
    private func toNextState(buttonID: Int) {
        if selectState.clickState == 0 {
            selectState.clickState = 1
            selectState.buttonType = ButtonType.cover
            selectState.buttonId = buttonID
        } else if selectState.clickState == 1{
            if(selectState.buttonId == buttonID && selectState.buttonType == ButtonType.cover) {
                if showConfirmation {
                    self.prevState = 0
                    self.nextStateId = 1
                    self.state = 4
                    showHelpButton = false
                    self.rowState = buttonID
                    selectState.clickState = 0
                } else {
                    showHelpButton = false
                    self.rowState = buttonID
                    state = 1
                    selectState.clickState = 1
                    selectState.buttonType = ButtonType.row
                    selectState.buttonId = getFirstRow()
                    selectState.clickState = 0
                }
            } else {
                selectState.buttonType = ButtonType.cover
                selectState.buttonId = buttonID
            }
        }
        // tells backspace another button has been pushed
        highlightBackspace = false
    }
    
    private func addSpace() {
        
        if selectState.clickState == 0 {
            selectState.clickState = 1
            selectState.buttonType = ButtonType.space
            selectState.buttonId = 0
        } else if selectState.clickState == 1{
            if(selectState.buttonType == ButtonType.space) {
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
                content = content1 + " " + content2
                contentInd = contentInd + 1
            } else {
                selectState.buttonType = ButtonType.space
            }
        }
        // tells backspace another button has been pushed
        highlightBackspace = false
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
}

struct CoverButtons_Previews: PreviewProvider {
    static var tempSelect = selectedState(buttonType: ButtonType.cover, buttonId: 0, clickState: 0, isNo: false)
    static var tempVm = ViewModel()
    static var tempTimer = Timer()
    
    static var previews: some View {
        
        CoverButtons(state: .constant(0), rowState: .constant(0), content: .constant(""), contentInd: .constant(0), prevState: .constant(0), selectState: .constant(tempSelect), highlightBackspace: .constant(false), queue: .constant([]), value: .constant(0), showHelpButton: .constant(false), highlightCursor: .constant(false), playSound: .constant(true), showConfirmation: .constant(true), showSave: .constant(false), customList: .constant([]), nextStateId: .constant(1), prevButtonType: .constant(ButtonType.cover))
    }
}

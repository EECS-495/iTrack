//
//  TextButton.swift
//  Track
//
//  Created by Danielle Maraffino on 1/31/23.
//

import SwiftUI
import AVFoundation

struct CoverButtons: View {
    
    @State var tutorialTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
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
        
    var body: some View {
        VStack{
            Button(action: {tutorial()}) {
                Text("?")
                    .foregroundColor(.black)
                    .overlay(
                        Circle()
                            .stroke(Color.black)
                            .frame(width: 20, height: 20)
                    )
            }
            .scaleEffect(showHelpButton ? 1 : 0.001)
            .onReceive(tutorialTimer) {_ in
                if(state == 0){
                    showHelpButton = true
                }
            }
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
            HStack{
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
    
    private func highlightSettings() {
        selectState.buttonId = 0
        selectState.buttonType = ButtonType.enterSettings
    }
    
    private func goToSettings() {
        // change selectState
        // change actual state
        selectState.buttonType = ButtonType.settingToggle
        selectState.buttonId = 0
        state = 3
    }
    
    private func tutorial() {
        print("tutorial")
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
                goToBackspace()
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
            goToCover(buttonId: 3)
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
                highlightSettings()
            }
        } else if curType == ButtonType.space {
            // go to lower
            goToCover(buttonId: 3)
        } else if curType == ButtonType.backspace {
            //go to upper
            highlightBackspace = false
            goToCover(buttonId: 0)
        } else if curType == ButtonType.cursor {
            // go to upper
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
            highlightBackspace = false
            goToCursor()
        } else if curType == ButtonType.cursor {
            // call cursorLeft
            moveCursorLeft()
        }
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
            goToSettings()
        } else {
            // cover was selected
            state = 4
            showHelpButton = false
            rowState = selectState.buttonId
            selectState.clickState = 1
            selectState.buttonType = ButtonType.confirm
            selectState.isNo = false
            prevState = 0
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
                self.prevState = 0
                self.state = 4
                showHelpButton = false
                self.rowState = buttonID
                selectState.clickState = 0
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
}

struct CoverButtons_Previews: PreviewProvider {
    static var tempSelect = selectedState(buttonType: ButtonType.cover, buttonId: 0, clickState: 0, isNo: false)
    static var tempVm = ViewModel()
    static var tempTimer = Timer()
    
    static var previews: some View {
        
        CoverButtons(state: .constant(0), rowState: .constant(0), content: .constant(""), contentInd: .constant(0), prevState: .constant(0), selectState: .constant(tempSelect), highlightBackspace: .constant(false), queue: .constant([]), value: .constant(0), showHelpButton: .constant(false), highlightCursor: .constant(false), playSound: .constant(true))
    }
}

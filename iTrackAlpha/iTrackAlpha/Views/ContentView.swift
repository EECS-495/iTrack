//
//  ContentView.swift
//  Track
//
//  Created by Danielle Maraffino on 1/31/23.
//

import SwiftUI
import AVFoundation

enum ButtonType {
    case cover, row , char, space, backspace, confirm, cursor, settingToggle, enterSettings, customPhrase, enterPhrases, addNewPhrase, tutorial, settingTutorial, exit
}

struct selectedState {
    var buttonType: ButtonType
    var buttonId: Int
    var clickState: Int
    var isNo:  Bool
}

struct CustomColor {
    static let lightgray = Color("lightgray")
}

struct CustomPhrase: Identifiable {
    var id: Int
    var content: String = ""
}


struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    // remove later
    @State var lastAction: String
    // end remove later
    @State var audioPlayer: AVAudioPlayer!
    @State var content: String = ""
    @State var contentInd: Int = 0
    @State var state: Int = 0
    @State var rowState: Int = 0
    @State var charState: Int = 0
    @State var prevState: Int = 0
    @State var nextStateId: Int = 0
    @State var customState: String = ""
    @State var selectState: selectedState = selectedState(buttonType: ButtonType.cover, buttonId: 0, clickState: 1, isNo: false)
    @State var showHelpButton: Bool = false
    @State var highlightBackspace: Bool = false
    @State var highlightCursor: Bool = false
    @State var customPhraseList: [CustomPhrase] = [CustomPhrase(id: 0, content: "Hello!")]
    @State var showSave: Bool = false
    @State var prevButtonType: ButtonType = ButtonType.cover
    @ObservedObject var customizations: CustomizationObject
    var longDelay: CGFloat = 2.0
    var shortDelay: CGFloat = 1.0
    
    var body: some View {
       
        VStack{
            if state != 3 && state != 6 {
                HStack{
                    CustomTextFieldView(content: $content, contentInd: $contentInd, highlightCursor: $highlightCursor)
                        .padding()
                    Spacer()
                    Button(action: {deleteChar()}) {
                        Image(backspaceImage())
                            .resizable()
                            .frame(width: backspaceWidth(), height: backspaceHeight())
                            .padding()
                    }
                }
                if showSave && state != 4{
                    HStack{
                        Button(action: {exitCustomPhrase()}) {
                            Text("Exit")
                                .frame(width: newWidthDim(buttonType: ButtonType.exit), height: newHeightDim(buttonType: ButtonType.exit))
                                .foregroundColor(.black)
                                .background(Color(red: 0.83, green: 0.83, blue: 0.83))
                                .border(.blue, width: addBorder(buttonType: ButtonType.exit))
                                .cornerRadius(8)
                        }
                        .padding([.leading])
                        Spacer()
                        Button(action: {savePhrase()}) {
                            Text("Save Custom text")
                                .frame(width: newWidthDim(buttonType: ButtonType.addNewPhrase), height: newHeightDim(buttonType: ButtonType.addNewPhrase))
                                .foregroundColor(saveColor())
                                .background(Color(red: 0.83, green: 0.83, blue: 0.83))
                                .border(.blue, width: addBorder(buttonType: ButtonType.addNewPhrase))
                                .cornerRadius(8)
                        }
                        .padding([.trailing])
                    }
                }
                Spacer()
            }
            if state == 0{
                CoverButtons(state: $state, rowState: $rowState, content: $content, contentInd: $contentInd, prevState: $prevState, selectState: $selectState, highlightBackspace: $highlightBackspace, queue: $viewModel.queue, value: $viewModel.value, showHelpButton: $showHelpButton, highlightCursor: $highlightCursor, playSound: $customizations.playSound, showConfirmation: $customizations.showConfirmationScreen, showSave: $showSave, customList: $customPhraseList, nextStateId: $nextStateId, prevButtonType: $prevButtonType)
            } else if state == 1{
                RowsView(state: $state, rowState: $rowState, charState: $charState, prevState: $prevState, selectState: $selectState, highlightBackspace: $highlightBackspace, queue: $viewModel.queue, value: $viewModel.value, content: $content, contentInd: $contentInd, highlightCursor: $highlightCursor, playSound: $customizations.playSound, showConfirmation: $customizations.showConfirmationScreen, showSave: $showSave, customList: $customPhraseList, nextStateId: $nextStateId, prevButtonType: $prevButtonType)
            } else if state == 2 {
                CharView(state: $state, rowState: $rowState, charState: $charState, content: $content, contentInd: $contentInd, prevState: $prevState, selectState: $selectState, highlightBackspace: $highlightBackspace, queue: $viewModel.queue, value: $viewModel.value, highlightCursor: $highlightCursor, playSound: $customizations.playSound, currentCharId: 0, showConfirmation: $customizations.showConfirmationScreen, showSave: $showSave, customList: $customPhraseList, nextStateId: $nextStateId, prevButtonType: $prevButtonType)
            } else if state == 3 {
                SettingsView(longerBlinkDelay: $customizations.longerBlinkDelay, longerGazeDelay: $customizations.longerGazeDelay, playSound: $customizations.playSound, showConfirmationScreen: $customizations.showConfirmationScreen, selectState: $selectState, queue: $viewModel.queue, value: $viewModel.value, state: $state, nextStateId: $nextStateId, prevState: $prevState, rowState: $rowState)
            } else if state == 4 {
                ConfirmationPopup(state: $state, rowState: $rowState, charState: $charState, prevState: $prevState, nextStateId: $nextStateId, selectState: $selectState, content: $content, contentInd: $contentInd, queue: $viewModel.queue, value: $viewModel.value, highlightBackspace: $highlightBackspace, highlightCursor: $highlightCursor, playSound: $customizations.playSound, customState: $customState, showSave: $showSave, customList: $customPhraseList, prevButtonType: $prevButtonType)
                Spacer()
            } else if state == 5 {
                CustomPhrasesView(customList: $customPhraseList, content: $content, contentInd: $contentInd, state: $state, showSave: $showSave, queue: $viewModel.queue, value: $viewModel.value, selectState: $selectState, highlightBackspace: $highlightBackspace, highlightCursor: $highlightCursor, prevState: $prevState, showConfirmation: $customizations.showConfirmationScreen, customState: $customState, nextStateId: $nextStateId, prevButtonType: $prevButtonType)
            } else if state == 6 {
                TutorialView(selectState: $selectState, queue: $viewModel.queue, value: $viewModel.value, state: $state, rowState: $rowState, prevState: $prevState, nextStateId: $nextStateId, showConfirmation: $customizations.showConfirmationScreen)
            }
            Spacer()
        }
        .onChange(of: state) { _ in
            if customizations.playSound {
                makeSound()
            }
        }
        .background(Color.white)
    }
    
    private func registerBlinkContent() {
        if selectState.buttonType == ButtonType.addNewPhrase && showSave {
            savePhrase()
        }
    }
    
    private func addBorder(buttonType: ButtonType) -> CGFloat {
        if selectState.buttonType == buttonType && showSave {
            return 3.0
        } else {
            return 0.0
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
    
    private func goToState(stateIn: Int) {
        state = stateIn
    }
    
    private func deleteChar() {
        if selectState.clickState == 0 {
            selectState.clickState = 1
            selectState.buttonType = ButtonType.backspace
            selectState.buttonId = 0
            highlightBackspace = true
        } else if selectState.clickState == 1 {
            if selectState.buttonType == ButtonType.backspace {
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

            } else {
                selectState.buttonType = ButtonType.backspace
                selectState.buttonId = 0
                highlightBackspace = true
            }
        }
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
    
    private func tutorial() {
        print("tutorial")
    }
    
    private func backspaceImage() -> String {
        if highlightBackspace {
            return "blueBackspace"
        } else {
            return "backspace"
        }
    }
    
    private func backspaceWidth() -> CGFloat {
        if highlightBackspace {
            return 55
        } else {
            return 45
        }
    }
    
    private func backspaceHeight() -> CGFloat {
        if highlightBackspace {
            return 40
        } else {
            return 30
        }
    }
    
    private func savePhrase() {
        let newId = customPhraseList.count
        customPhraseList.append(CustomPhrase(id: newId, content: self.content))
        showSave = false
        content = ""
        state = 5
    }
    
    private func newWidthDim(buttonType: ButtonType) -> CGFloat {
        if selectState.buttonType == buttonType && showSave{
            return 160
        } else {
            return 140
        }
    }
    
    private func newHeightDim(buttonType: ButtonType) -> CGFloat {
        if selectState.buttonType == buttonType && showSave {
            return 65
        } else {
            return 45
        }
    }
    
    private func exitCustomPhrase() {
        showSave = false
        if customizations.showConfirmationScreen {
            // go to confirmation screen
            selectState.buttonType = ButtonType.customPhrase
            selectState.buttonId = 0
            selectState.clickState = 0
            state = 5
        } else {
            selectState.buttonType = ButtonType.customPhrase
            selectState.buttonId = 0
            selectState.clickState = 0
            state = 5
        }
    }
    
    private func saveColor() -> Color {
        if !content.isEmpty {
            return Color.black
        } else {
            return Color(white: 0.4745)
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static private var tempVm = ViewModel()
    static private var tempCust = CustomizationObject()
    static var previews: some View {
        ContentView(viewModel: tempVm, lastAction: "", customizations: tempCust)
            .previewInterfaceOrientation(.portrait)
    }
}

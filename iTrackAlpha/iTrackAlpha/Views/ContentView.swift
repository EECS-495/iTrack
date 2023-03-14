//
//  ContentView.swift
//  Track
//
//  Created by Danielle Maraffino on 1/31/23.
//

import SwiftUI
import AVFoundation

enum ButtonType {
    case cover, row , char, space, backspace, confirm, cursor, settingToggle, enterSettings
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
    @State var selectState: selectedState = selectedState(buttonType: ButtonType.cover, buttonId: 0, clickState: 1, isNo: false)
    @State var showHelpButton: Bool = false
    @State var highlightBackspace: Bool = false
    @State var highlightCursor: Bool = false
    @ObservedObject var customizations: CustomizationObject
    
    var body: some View {
       
        VStack{
            if state != 3 {
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
                Spacer()
            }
            if state == 0{
                CoverButtons(state: $state, rowState: $rowState, content: $content, contentInd: $contentInd, prevState: $prevState, selectState: $selectState, highlightBackspace: $highlightBackspace, queue: $viewModel.queue, value: $viewModel.value, showHelpButton: $showHelpButton, highlightCursor: $highlightCursor, playSound: $customizations.playSound, showConfirmation: $customizations.showConfirmationScreen)
            } else if state == 1{
                RowsView(state: $state, rowState: $rowState, charState: $charState, prevState: $prevState, selectState: $selectState, highlightBackspace: $highlightBackspace, queue: $viewModel.queue, value: $viewModel.value, content: $content, contentInd: $contentInd, highlightCursor: $highlightCursor, playSound: $customizations.playSound, showConfirmation: $customizations.showConfirmationScreen)
            } else if state == 2 {
                CharView(state: $state, rowState: $rowState, charState: $charState, content: $content, contentInd: $contentInd, prevState: $prevState, selectState: $selectState, highlightBackspace: $highlightBackspace, queue: $viewModel.queue, value: $viewModel.value, highlightCursor: $highlightCursor, playSound: $customizations.playSound, currentCharId: 0, showConfirmation: $customizations.showConfirmationScreen)
            } else if state == 3 {
                SettingsView(blinkDelay: $customizations.blinkDelayAmt, gazeDelay: $customizations.gazeDelayAmt, playSound: $customizations.playSound, showConfirmationScreen: $customizations.showConfirmationScreen, selectState: $selectState, queue: $viewModel.queue, value: $viewModel.value, state: $state)
            } else if state == 4 {
                ConfirmationPopup(state: $state, rowState: $rowState, charState: $charState, prevState: $prevState, selectState: $selectState, content: $content, contentInd: $contentInd, queue: $viewModel.queue, value: $viewModel.value, highlightBackspace: $highlightBackspace, highlightCursor: $highlightCursor, playSound: $customizations.playSound)
                Spacer()
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

}

struct ContentView_Previews: PreviewProvider {
    static private var tempVm = ViewModel()
    static private var tempCust = CustomizationObject()
    static var previews: some View {
        ContentView(viewModel: tempVm, lastAction: "", customizations: tempCust)
            .previewInterfaceOrientation(.portrait)
    }
}

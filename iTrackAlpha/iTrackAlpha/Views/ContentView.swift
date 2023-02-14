//
//  ContentView.swift
//  Track
//
//  Created by Danielle Maraffino on 1/31/23.
//

import SwiftUI

enum ButtonType {
    case cover, row , char, space, backspace, confirm
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
    @State var content: String = ""
    @State var contentInd: Int = 0
    @State var state: Int = 0
    @State var rowState: Int = 0
    @State var charState: Int = 0
    @State var prevState: Int = 0
    @State var selectState: selectedState = selectedState(buttonType: ButtonType.cover, buttonId: 0, clickState: 1, isNo: false)
    let tutorialTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @State var showHelpButton: Bool = false
    @State var highlightBackspace: Bool = false
    
    var body: some View {
       
        VStack{
            HStack{
                CustomTextFieldView(content: $content, contentInd: $contentInd)
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
            Text("last action was \(lastAction)")
                .foregroundColor(.black)
            Spacer()
            HStack {
                Button(action: moveCursorLeft){
                    Text("Cursor Left")
                }
                .padding()
                Spacer()
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
                    showHelpButton = true
                }
                Spacer()
                Button(action: moveCursorRight){
                    Text("Cursor Right")
                }
                .padding()
            }
            Spacer()
            if state == 0{
                CoverButtons(state: $state, rowState: $rowState, content: $content, contentInd: $contentInd, prevState: $prevState, selectState: $selectState, highlightBackspace: $highlightBackspace, queue: $viewModel.queue, value: $viewModel.value)
            } else if state == 1{
                RowsView(state: $state, rowState: $rowState, charState: $charState, prevState: $prevState, selectState: $selectState, highlightBackspace: $highlightBackspace, queue: $viewModel.queue, value: $viewModel.value, content: $content, contentInd: $contentInd)
            } else if state == 2 {
                CharView(state: $state, charState: $charState, content: $content, contentInd: $contentInd, prevState: $prevState, selectState: $selectState, highlightBackspace: $highlightBackspace, queue: $viewModel.queue, value: $viewModel.value)
            } else if state == 4 {
                ConfirmationPopup(state: $state, rowState: $rowState, charState: $charState, prevState: $prevState, selectState: $selectState, content: $content, contentInd: $contentInd, queue: $viewModel.queue, value: $viewModel.value, highlightBackspace: $highlightBackspace)
                Spacer()
            }
            Spacer()
        }
        .background(Color.white)
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
//                highlightBackspace = false
//                selectState.clickState = 0
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
        print(contentInd)
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
    static var previews: some View {
        ContentView(viewModel: tempVm, lastAction: "")
            .previewInterfaceOrientation(.portrait)
    }
}

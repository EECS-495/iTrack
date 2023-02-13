//
//  TextButton.swift
//  Track
//
//  Created by Danielle Maraffino on 1/31/23.
//

import SwiftUI

struct CoverButtons: View {
    
    @Binding var state: Int
    @Binding var rowState: Int
    @Binding var content: String
    @Binding var contentInd: Int
    @Binding var prevState: Int
    @Binding var selectState: selectedState
    @Binding var highlightBackspace: Bool
  
    var body: some View {
        VStack{
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
                        .background(CustomColor.lightgray)
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
        }
        .padding()
    }
    
    private func addBorder(buttonType: ButtonType, buttonId: Int) -> CGFloat {
        if selectState.buttonType == buttonType && selectState.buttonId == buttonId && selectState.clickState == 1{
            return 3.0
        } else {
            return 0
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
    static var tempSelect = selectedState(buttonType: ButtonType.cover, buttonId: 0, clickState: 0)
    
    static var previews: some View {
        
        CoverButtons(state: .constant(0), rowState: .constant(0), content: .constant(""), contentInd: .constant(0), prevState: .constant(0), selectState: .constant(tempSelect), highlightBackspace: .constant(false))
    }
}

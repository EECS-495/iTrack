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
  
    var body: some View {
        VStack{
            Button(action: {toNextState(buttonID: 0)}){
                Image("uppercover")
            }
            
            HStack{
                Button(action: {toNextState(buttonID: 1)}){
                    Image("symbolscover")
                }
                
                Spacer()
                Button(action: addSpace){
                    Text("Space")
                        .frame(width: 60, height: 60)
                        .foregroundColor(.black)
                        .background(.gray)
                }
                Spacer()
                Button(action: {toNextState(buttonID: 2)}){
                    Image("numberscover")
                }
            }
            Button(action: {toNextState(buttonID: 3)}){
                Image("lowercover")
            }
        }
        .padding()
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
        
    }
}

struct CoverButtons_Previews: PreviewProvider {
    static var tempSelect = selectedState(buttonType: ButtonType.cover, buttonId: 0, clickState: 0)
    
    static var previews: some View {
        
        CoverButtons(state: .constant(0), rowState: .constant(0), content: .constant(""), contentInd: .constant(0), prevState: .constant(0), selectState: .constant(tempSelect))
    }
}

//
//  CharView.swift
//  Track
//
//  Created by Danielle Maraffino on 2/2/23.
//

import SwiftUI

struct CharView: View {
    @Binding var state: Int
    @Binding var charState: Int
    @Binding var content: String
    @Binding var contentInd: Int
    @Binding var prevState: Int
    @Binding var selectState: selectedState
    
    var charRows: [CharRow] {
        CharRows.filter { row in
            (row.CharType == charState)
        }
    }
    var body: some View {
        ScrollView{
            ForEach(charRows) { row in
                Button(action: {clickChar(character: row)}){
                    Text(row.character)
                        .frame(width: scaleDim(row: row), height: scaleDim(row: row))
                        .font(.largeTitle)
                        .background(CustomColor.lightgray)
                        .foregroundColor(.black)
                        .border(.blue, width: addBorder(row: row))
                        .cornerRadius(8)
                }
                .padding(.horizontal, 170)
                .padding(.vertical, 10)
            }
        }
        .modifier(GestureSwipeRight(state: $state))
    }
    
    private func clickChar(character: CharRow) {
        print(selectState.clickState)
        if selectState.clickState == 0 {
            selectState.clickState = 1
            selectState.buttonType = ButtonType.char
            selectState.buttonId = character.id
        } else if selectState.clickState == 1 {
            if selectState.buttonType == ButtonType.char && selectState.buttonId == character.id {
                prevState = 2
                state = 4
                selectState.clickState = 0
            } else {
                selectState.buttonId = character.id
                selectState.buttonType = ButtonType.char
            }
        }
    }
    
    private func scaleDim(row: CharRow) -> CGFloat {
        if selectState.clickState == 1 && selectState.buttonType == ButtonType.char && selectState.buttonId == row.id {
            return 100
        } else {
            return 60
        }
    }
    
    private func addBorder(row: CharRow) -> CGFloat {
        if selectState.clickState == 1 && selectState.buttonType == ButtonType.char && selectState.buttonId == row.id {
            return 3
        } else {
            return 0
        }
    }
}

struct CharView_Previews: PreviewProvider {
    static var tempSelect = selectedState(buttonType: ButtonType.cover, buttonId: 0, clickState: 0)
    
    static var previews: some View {
        CharView(state: .constant(2), charState: .constant(0), content: .constant(""), contentInd: .constant(0), prevState: .constant(2), selectState: .constant(tempSelect))
    }
}


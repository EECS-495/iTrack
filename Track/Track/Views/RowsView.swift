//
//  UpperRows.swift
//  Track
//
//  Created by Danielle Maraffino on 2/1/23.
//

import SwiftUI

struct RowsView: View {
    @Binding var state: Int
    @Binding var rowState: Int
    @Binding var charState: Int
    @Binding var prevState: Int
    @Binding var selectState: selectedState
    
    var rows: [Row] {
        Rows.filter { row in
            (row.RowType == rowState)
        }
    }
    
    var body: some View {
        VStack{
            Spacer()
            ForEach(rows) { row in
                Button(action: {
                    clickRow(row)
                }){
                    Image(row.image)
                        .resizable()
                        .border(.blue, width: addBorder(buttonId: row.id))
                        .frame(width: scaleDimWidth(buttonId: row.id), height: scaleDimHeight(buttonId: row.id))
                }
                .padding()
            }
            Spacer()
        }
        .modifier(GestureSwipeRight(state: $state))
    }
    
    private func scaleDimWidth(buttonId: Int) -> CGFloat {
        if selectState.buttonType == ButtonType.row && selectState.buttonId == buttonId && selectState.clickState == 1 {
            return 380
        } else {
            return 330
        }
    }
    
    private func scaleDimHeight (buttonId: Int) -> CGFloat {
        if selectState.buttonType == ButtonType.row && selectState.buttonId == buttonId && selectState.clickState == 1 {
            return 55
        } else {
            return 35
        }
    }
    
    private func addBorder (buttonId: Int) -> CGFloat {
        if selectState.buttonType == ButtonType.row && selectState.buttonId == buttonId && selectState.clickState == 1 {
            return 3.0
        } else {
            return 0
        }
    }
    
    private func clickRow(_ row: Row){
//        self.state = 4
//        self.prevState = 1
//        self.charState = row.CharType
        if selectState.clickState == 0 {
            selectState.clickState = 1
            selectState.buttonType = ButtonType.row
            selectState.buttonId = row.id
        } else if selectState.clickState == 1 {
            if(selectState.buttonId == row.id && selectState.buttonType == ButtonType.row) {
                self.prevState = 1
                self.state = 4
                self.charState = row.CharType
                selectState.clickState = 0
            } else {
                selectState.buttonType = ButtonType.row
                selectState.buttonId = row.id
            }
        }
        
    }
    
}

struct RowsView_Previews: PreviewProvider {
    static var tempSelect = selectedState(buttonType: ButtonType.cover, buttonId: 0, clickState: 0)
    
    static var previews: some View {
        RowsView(state: .constant(2), rowState: .constant(0), charState: .constant(0), prevState: .constant(1), selectState: .constant(tempSelect))
    }
}

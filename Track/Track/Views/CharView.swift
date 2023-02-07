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
    
    var charRows: [CharRow] {
        CharRows.filter { row in
            (row.CharType == charState)
        }
    }
    var body: some View {
        ScrollView{
            ForEach(charRows) { row in
                Button(action: {clickChar(character: row.character)}){
                    Text(row.character)
                        .frame(width: 70, height: 70)
                        .font(.largeTitle)
                        .background(.gray)
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 170)
                .padding(.vertical, 10)
            }
        }
        .modifier(GestureSwipeRight(state: $state))
    }
    
    private func clickChar(character: String) {
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
        content = content1 + character + content2
        contentInd = contentInd + 1
        state = 1
    }
}

struct CharView_Previews: PreviewProvider {
    static var previews: some View {
        CharView(state: .constant(2), charState: .constant(0), content: .constant(""), contentInd: .constant(0))
    }
}

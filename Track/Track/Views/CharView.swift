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
        content = content + character
    }
}

struct CharView_Previews: PreviewProvider {
    static var previews: some View {
        CharView(state: .constant(2), charState: .constant(0), content: .constant(""))
    }
}

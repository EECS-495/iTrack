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
                    clickRow(row.CharType)
                }){
                    Image(row.image)
                        .resizable()
                        .scaledToFit()
                }
                .padding()
            }
            Spacer()
        }
        .modifier(GestureSwipeRight(state: $state))
    }
    private func clickRow(_ CharType: Int){
        // check row state to skip to checking image name to know what to set char state to be
        //self.state = 2
        self.state = 4
        self.prevState = 1
        self.charState = CharType
        
    }
    
}

struct RowsView_Previews: PreviewProvider {
    static var previews: some View {
        RowsView(state: .constant(2), rowState: .constant(0), charState: .constant(0), prevState: .constant(1))
    }
}

//
//  ConfirmationPopup.swift
//  Track
//
//  Created by Amanda Beger on 2/7/23.
//

import SwiftUI

struct ConfirmationPopup: View {
    @Binding var state: Int
    @Binding var rowState: Int
    @Binding var charState: Int
    @Binding var prevState: Int
        
    
    var body: some View {
        
        VStack {
            
            if($prevState.wrappedValue == 0){
                if ($rowState.wrappedValue == 0) {
                    Text("Did you mean to select: upper case");
                } else if ($rowState.wrappedValue == 1) {
                    Text("Did you mean to select: symbols");
                } else if ($rowState.wrappedValue == 2) {
                    Text("Did you mean to select: numbers");
                } else if ($rowState.wrappedValue == 3){
                    Text("Did you mean to select: lower case");
                }
            } else if ($prevState.wrappedValue == 1) {
                if ($charState.wrappedValue == 0) {
                    Text("Did you mean to select: QWERTYUIOP");
                } else if ($charState.wrappedValue == 1) {
                    Text("Did you mean to select: ASDFGHJKL");
                } else if ($charState.wrappedValue == 2) {
                    Text("Did you mean to select: ZXCVBNM");
                } else if ($charState.wrappedValue == 3) {
                    Text("Did you mean to select: -/:;()$&@\"");
                } else if ($charState.wrappedValue == 4) {
                    Text("Did you mean to select: []{}#%^*+= ");
                } else if ($charState.wrappedValue == 5) {
                    Text("Did you mean to select: _\\|~<>");
                } else if ($charState.wrappedValue == 6) {
                    Text("Did you mean to select: .,?!'");
                } else if ($charState.wrappedValue == 7) {
                    Text("Did you mean to select: 01234");
                } else if ($charState.wrappedValue == 8) {
                    Text("Did you mean to select: 56789");
                } else if ($charState.wrappedValue == 9) {
                    Text("Did you mean to select: qwertyuiop");
                } else if ($charState.wrappedValue == 10){
                    Text("Did you mean to select: asdfghjkl");
                } else if ($charState.wrappedValue == 11){
                    Text("Did you mean to select: zxcvbnm");
                }
            }
            
            HStack {
                Button(action: nextState) {
                    Text("Yes")
                        .frame(width: 60, height: 60)
                        .foregroundColor(.black)
                        .background(.gray)
                }
                Button(action: lastState) {
                    Text("No")
                        .frame(width: 60, height: 60)
                        .foregroundColor(.black)
                        .background(.gray)
                }
            }
        }
    }
    
    private func nextState() {
        self.state = self.prevState + 1
        self.rowState = $rowState.wrappedValue
        self.charState = $charState.wrappedValue
    }
    
    private func lastState() {
        self.state = self.prevState
    }
}

struct ConfirmationPopup_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationPopup(state: .constant(1), rowState: .constant(1), charState: .constant(0), prevState: .constant(0))
    }
}

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
  
    var body: some View {
        VStack{
            Button(action: toUpperState){
                Image("uppercover")
            }
            HStack{
                Button(action: toSymbolState){
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
                Button(action: toNumbersState){
                    Image("numberscover")
                }
            }
            Button(action: toLowerState){
                Image("lowercover")
            }
        }
        .padding()
    }
    
    
    private func toUpperState() {
        self.state = 1
        self.rowState = 0
    }
    private func toSymbolState() {
        self.state = 1
        self.rowState = 1
    }
    private func toNumbersState() {
        self.state = 1
        self.rowState = 2
    }
    private func toLowerState() {
        self.state = 1
        self.rowState = 3
    }
    private func addSpace() {
        content = content + " "
    }
}

struct CoverButtons_Previews: PreviewProvider {
    static var previews: some View {
        CoverButtons(state: .constant(0), rowState: .constant(0), content: .constant(""))
    }
}

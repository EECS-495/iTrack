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
    }
}

struct CoverButtons_Previews: PreviewProvider {
    static var previews: some View {
        CoverButtons(state: .constant(0), rowState: .constant(0), content: .constant(""), contentInd: .constant(0))
    }
}

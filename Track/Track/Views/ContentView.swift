//
//  ContentView.swift
//  Track
//
//  Created by Danielle Maraffino on 1/31/23.
//

import SwiftUI

struct ContentView: View {
    @State var content: String = ""
    @State var state: Int = 0
    @State var rowState: Int = 0
    @State var charState: Int = 0
    
    var body: some View {
       
        VStack{
            HStack{
                TextField("Enter Text Using Buttons Below", text: $content)
                    .padding()
                Spacer()
                Button(action: {deleteChar()}) {
                    Image("backspace")
                        .resizable()
                        .frame(width: 45, height: 30)
                }
            }
            Spacer()
            if state == 0{
                CoverButtons(state: $state, rowState: $rowState, content: $content)
            } else if state == 1{
                RowsView(state: $state, rowState: $rowState, charState: $charState)
            } else if state == 2 {
                CharView(state: $state, charState: $charState, content: $content)
            }
            Spacer()
        }
    }
    
    private func deleteChar() {
        if content.count > 0 {
            content.removeLast()
        }
    }
    private func addSpace(){
        content = content + " "
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  ContentView.swift
//  Track
//
//  Created by Danielle Maraffino on 1/31/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var content: String = ""
    @State var contentInd: Int = 0
    @State var state: Int = 0
    @State var rowState: Int = 0
    @State var charState: Int = 0
    
    var body: some View {
       
        VStack{
            HStack{
                CustomTextFieldView(content: $content, contentInd: $contentInd)
                    .padding()
                Spacer()
                Button(action: {deleteChar()}) {
                    Image("backspace")
                        .resizable()
                        .frame(width: 45, height: 30)
                        .padding()
                }
            }
            Spacer()
            HStack {
                Button(action: moveCursorLeft){
                    Text("Cursor Left")
                }
                .padding()
                Spacer()
                Button(action: moveCursorRight){
                    Text("Cursor Right")
                }
                .padding()
            }
            Spacer()
            if state == 0{
                CoverButtons(state: $state, rowState: $rowState, content: $content, contentInd: $contentInd)
            } else if state == 1{
                RowsView(state: $state, rowState: $rowState, charState: $charState)
            } else if state == 2 {
                CharView(state: $state, charState: $charState, content: $content, contentInd: $contentInd)
            }
            Spacer()
        }
        .background(Color.white)
    }
    
    private func deleteChar() {
        if contentInd > 0 {
            var count: Int = 0
            var content1: String = ""
            var content2: String = ""
            for char in Array(content) {
                if count >= contentInd - 1 {
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
            content = content1 + content2
            contentInd = contentInd - 1
        }
    }
    
    private func moveCursorLeft() {
        if contentInd > 0 {
            contentInd = contentInd - 1
        }
        print(contentInd)
    }
    
    private func moveCursorRight() {
        if contentInd < content.count {
            contentInd = contentInd + 1
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}

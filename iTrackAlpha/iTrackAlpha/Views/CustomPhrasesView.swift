//
//  CustomPhrasesView.swift
//  iTrackAlpha
//
//  Created by Amanda Beger on 3/15/23.
//

import SwiftUI

struct CustomPhrasesView: View {
    @Binding var customList: [CustomPhrase]
    @Binding var content: String
    @Binding var contentInd: Int
    @Binding var state: Int
    
    
    var body: some View {
        List(customList) { customPhrase in
            Button(action: {
                clickContent(customPhrase)
            }) {
                Text(customPhrase.content)
            }
            .padding()
        }
        
        Button(action: {addPhrase()}) {
            Text("Add New Custom Text")
        }
    }
    
    private func clickContent(_ customPhrase: CustomPhrase) {
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
        content = content1 + customPhrase.content + content2
        contentInd = contentInd + customPhrase.content.count
        state = 0
    }
    
    private func addPhrase() {
        
    }
}

struct CustomPhrasesView_Previews: PreviewProvider {
    static var tempCustom = CustomPhrase(id: 0, content: "")
    static var previews: some View {
        CustomPhrasesView(customList: .constant([]), content: .constant(""), contentInd: .constant(0), state: .constant(5))
    }
}

//
//  CustomTextFieldView.swift
//  Track
//
//  Created by Danielle Maraffino on 2/7/23.
//

import SwiftUI

struct CustomTextFieldView: View {
    @State var refresh: Int = 0
    @Binding var content: String
    @Binding var contentInd: Int
    var cursorColors: [Color] = [.blue, .white]
    @State private var currentColor: Color = .blue
    @State private var currentColorInd: Int = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let refreshTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack{
            if content == "" {
                Text("Enter Text Using Buttons Below")
                    .foregroundColor(.gray)
            } else {
                Group {
                    Text(firstHalf(content: content))
                        .foregroundColor(.black) +
                    Text("|")
                        .font(.system(size: 22, weight: .medium))
                        .kerning(-5)
                        .foregroundColor(currentColor) +
                    Text(secHalf(content: content) + " ")
                        .foregroundColor(.black)
                }
                .onReceive(timer) {_ in
                    currentColorInd = (currentColorInd + 1) % 2
                    currentColor = cursorColors[currentColorInd]
                }
            }
        }
        .onReceive(refreshTimer) {_ in
            refresh = (refresh + 1) % 2
        }
        
    }
    
    private func firstHalf(content: String) -> String{
        var content1: String = ""
        var count: Int = 0
        for char in Array(content) {
            if count >= contentInd {
                break
            }
            content1 = content1 + String(char)
            count = count + 1
        }
        return content1
    }
    
    private func secHalf(content: String) -> String {
        var content2: String = ""
        var count: Int = 0
        for char in Array(content) {
            if count >= contentInd {
                content2 = content2 + String(char)
            }
            count = count + 1
        }
        return content2
    }
    
    private func refreshFunc() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    refresh = (refresh + 1) % 2
                    refreshFunc()
                }
    }
    
}

struct CustomTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextFieldView(content: .constant("word"), contentInd: .constant(2))
    }
}

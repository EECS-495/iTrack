//
//  ClickButTutorialView.swift
//  iTrackAlpha
//
//  Created by Danielle Maraffino on 3/21/23.
//

import SwiftUI

struct ClickButTutorialView: View {
    var body: some View {
        VStack{
            HStack {
                Text("Clicking Buttons")
                    .padding([.leading, .trailing], 22)
                    .font(.title)
                    .foregroundColor(.blue)
                Spacer()
            }
            Text("When a button is highlighted with a blue border, as shown in the picture above, blink to click the button like how touch activates typical screen buttons")
                .padding([.leading, .trailing], 20)
                .padding(.top, 0.1)
                .foregroundColor(.black)
            
        }
    }
}

struct ClickButTutorialView_Previews: PreviewProvider {
    static var previews: some View {
        ClickButTutorialView()
    }
}

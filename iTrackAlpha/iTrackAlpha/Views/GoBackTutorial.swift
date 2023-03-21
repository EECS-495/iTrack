//
//  GoBackTutorial.swift
//  iTrackAlpha
//
//  Created by Danielle Maraffino on 3/21/23.
//

import SwiftUI

struct GoBackTutorial: View {
    var body: some View {
        VStack{
            HStack {
                Text("Return to Previous Screen")
                    .padding([.leading, .trailing], 20)
                    .font(.title)
                    .foregroundColor(.blue)
                Spacer()
            }
            Text("To return to a previous screen after navigating away, look past the left edge of the phone to essentially use a \"go back\" button. Looking left while in this tutorial will cause a return to home screen with the character categories")
                .padding([.top], 0.1)
                .padding([.leading], 17)
                .padding([.trailing], 17)
                .foregroundColor(.black)
        }
    }
}

struct GoBackTutorial_Previews: PreviewProvider {
    static var previews: some View {
        GoBackTutorial()
    }
}

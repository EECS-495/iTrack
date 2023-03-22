//
//  NavButtonsTutorialView.swift
//  iTrackAlpha
//
//  Created by Danielle Maraffino on 3/21/23.
//

import SwiftUI

struct NavButtonsTutorialView: View {
    var body: some View {
        VStack{
            HStack {
                Text("Navigating the Buttons")
                    .padding([.leading, .trailing], 22)
                    .font(.title)
                    .foregroundColor(.blue)
                Spacer()
            }
            Text("Looking up, down, left, or right will change the button on the screen that is being \"hovered over\". The button that is currently selected will be highlighted with a blue border, as shown below")
                .padding([.leading, .trailing], 17)
                .padding(.top, 0.1)
                .foregroundColor(.black)
            HStack{
                Text("A")
                    .frame(width: 50, height: 50)
                    .font(.largeTitle)
                    .background(Color(red: 0.83, green: 0.83, blue: 0.83))
                    .foregroundColor(.black)
                    .border(.blue, width: 3)
                    .cornerRadius(8)
                Text("vs")
                    .padding([.leading, .trailing])
                    .foregroundColor(.black)
                Text("A")
                    .frame(width: 50, height: 50)
                    .font(.largeTitle)
                    .background(Color(red: 0.83, green: 0.83, blue: 0.83))
                    .foregroundColor(.black)

                    .cornerRadius(8)
            }
            .padding()
        }
    }
}

struct NavButtonsTutorialView_Previews: PreviewProvider {
    static var previews: some View {
        NavButtonsTutorialView()
    }
}

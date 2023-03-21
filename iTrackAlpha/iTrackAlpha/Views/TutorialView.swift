//
//  TutorialView.swift
//  iTrackAlpha
//
//  Created by Danielle Maraffino on 3/20/23.
//

import SwiftUI

struct TutorialView: View {
    @Binding var selectState: selectedState // delete if you dont end up using blinking here
    @Binding var queue: [Action]
    @Binding var value: Int
    @Binding var state: Int
    @Binding var rowState: Int // only included to use GestureSwipeRight
    @Binding var prevState: Int // only included to use GestureSwipeRight
    
    var body: some View {
        VStack {
            Text("Tutorial")
                .font(.title)
                .foregroundColor(.blue)
            Spacer()
            NavButtonsTutorialView()
            Spacer()
            ClickButTutorialView()
            Spacer()
            GoBackTutorial()
            Spacer()
        }
        .modifier(GestureSwipeRight(state: $state, selectState: $selectState, prevState: $prevState, rowState: $rowState))
        .onChange(of: value ) { _ in
            if !queue.isEmpty {
                let action = queue.first!.actionType
                if action != ActionType.blink {
                    registerGaze(action: action)
                    queue.removeFirst()
                }
            }
        }
    }
    
    private func registerGaze(action: ActionType) {
        if action == ActionType.left {
            // go back to cover buttons
            state = 0
            selectState.buttonType = ButtonType.cover
            selectState.buttonId = 0
        }
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var tempSelect = selectedState(buttonType: ButtonType.cover, buttonId: 0, clickState: 0, isNo: false)
    
    static var previews: some View {
        TutorialView(selectState: .constant(tempSelect), queue: .constant([]), value: .constant(0), state: .constant(6), rowState: .constant(0), prevState: .constant(0))
    }
}

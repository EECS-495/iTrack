//
//  GestureSwipeRight.swift
//  Track
//
//  Created by Danielle Maraffino on 2/3/23.
//

import SwiftUI

struct GestureSwipeRight: ViewModifier {

    @Binding var state: Int
    
    func body(content: Content) -> some View {
    content
      .contentShape(Rectangle())  // This is what would make gesture
      .gesture(                   // accessible on all the View.
        DragGesture(minimumDistance: 30, coordinateSpace: .local)
          .onEnded { value in
            if value.translation.width > .zero
                && value.translation.height > -30
                && value.translation.height < 30 {

              // Add your actions here when user swipe right.
            if(state != 0 && state != 4) {
                state = state - 1
            }
            }
          }
      )
    }
}

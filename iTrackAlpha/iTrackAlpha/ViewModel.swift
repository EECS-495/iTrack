//
//  ViewModel.swift
//  iTrackAlpha
//
//  Created by Danielle Maraffino on 2/13/23.
//

import Foundation
import SwiftUI

enum ActionType {
    case blink, up, down, left, right, NONE
}

struct Action {
    var actionType: ActionType
}

class ViewModel: ObservableObject {
    @Published var value: Int = 0
    var queue = [Action]()
    
    func pop() -> Action {
        if !queue.isEmpty {
            return queue.removeFirst()
        }
        return Action(actionType: ActionType.NONE)
    }
    
    func push(action: Action){
        queue.append(action)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.value = (self.value + 1) % 2
        }
    }
    
    func addBlink() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.value = (self.value + 1) % 2
        }
    }
}

class CustomizationObject: ObservableObject {
    @Published var blinkDelayAmt: CGFloat = 1.0
    @Published var gazeDelayAmt: CGFloat = 1.0
    @Published var playSound: Bool = true
    @Published var showConfirmationScreen: Bool = true
}

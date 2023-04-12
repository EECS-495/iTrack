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
    @Published var longerBlinkDelay: Bool = false
    @Published var longerGazeDelay: Bool = false
    @Published var playSound: Bool = true
    @Published var showConfirmationScreen: Bool = true
    @Published var lookUpSens: CGFloat = 0.7
    @Published var lookDownSens: CGFloat = 0.35
    @Published var lookLeftSens: CGFloat = 0.7
    @Published var lookRightSens: CGFloat = 0.7
}

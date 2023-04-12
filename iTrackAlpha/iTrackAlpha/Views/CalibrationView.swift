//
//  CalibrationView.swift
//  iTrackAlpha
//
//  Created by Danielle Maraffino on 4/10/23.
//

import SwiftUI
import AVFoundation

struct CalibrationView: View {
    @Binding var state: Int
    @Binding var showConfirmationScreen: Bool
    @Binding var selectState: selectedState
    @Binding var queue: [Action]
    @Binding var value: Int
    @Binding var nextStateId: Int
    @Binding var prevState: Int
    @Binding var lookUpSens: CGFloat
    @Binding var lookDownSens: CGFloat
    @Binding var lookLeftSens: CGFloat
    @Binding var lookRightSens: CGFloat
    @Binding var blinkSens: CGFloat
    @Binding var playSound: Bool
    @State var audioPlayer: AVAudioPlayer!
    @State var calibrationState: CalibrationState = CalibrationState.buttons
    @State var inCalibrationConfirmation: Bool = false // are we waiting for user action or askng the user to adjust the sensitivity, here to avoid a million calibration states and next/prev states
    // below are values the user entered calibration with
    @State var origLookUp: CGFloat = 0
    @State var origLookDown: CGFloat = 0
    @State var origLookLeft: CGFloat = 0
    @State var origLookRight: CGFloat = 0
    @State var origBlink: CGFloat = 0
    @State var setOriginals: Bool = false
    // below are our default values, different from user's initial values
    @State var defaultUp: CGFloat = 0.7
    @State var defaultDown: CGFloat = 0.35
    @State var defaultLeft: CGFloat = 0.7
    @State var defaultRight: CGFloat = 0.7
    @State var defaultBlink: CGFloat = 0.9
    
    var body: some View {
        VStack{
            Text("Turn on sound to calibrate your eye tracking")
            Spacer()
            if !inCalibrationConfirmation {
                if calibrationState == CalibrationState.buttons {
                    CalibrationButtonsView(state: $state, calibrationState: $calibrationState, selectState: $selectState, queue: $queue, value: $value, showConfirmationScreen: $showConfirmationScreen, nextStateId: $nextStateId, prevState: $prevState, playSound: $playSound, lookUpSens: $lookUpSens, lookDownSens: $lookDownSens, lookLeftSens: $lookLeftSens, lookRightSens: $lookRightSens, blinkSens: $blinkSens, defaultUp: $defaultUp, defaultDown: $defaultDown, defaultLeft: $defaultLeft, defaultRight: $defaultRight, defaultBlink: $defaultBlink)
                } else if calibrationState == CalibrationState.up || calibrationState == CalibrationState.down || calibrationState == CalibrationState.left || calibrationState == CalibrationState.right || calibrationState == CalibrationState.blink {
                    GazeCalibrationView(calibrationState: $calibrationState, selectState: $selectState, queue: $queue, value: $value, lookUpSens: $lookUpSens, lookDownSens: $lookDownSens, lookLeftSens: $lookLeftSens, lookRightSens: $lookRightSens, blinkSens: $blinkSens,  inCalibrationConfirmation: $inCalibrationConfirmation)
                    Spacer()
                }
            } else {
                CalibrationConfirmationView(calibrationState: $calibrationState, selectState: $selectState, queue: $queue, value: $value, lookUpSens: $lookUpSens, lookDownSens: $lookDownSens, lookLeftSens: $lookLeftSens, lookRightSens: $lookRightSens, blinkSens: $blinkSens, origLookUp: $origLookUp, origLookDown: $origLookDown, origLookLeft: $origLookLeft, origLookRight: $origLookRight, origBlink: $origBlink, inCalibrationConfirmation: $inCalibrationConfirmation, playSound: $playSound)
            }
        }
        .onAppear{
            if !setOriginals {
                setOriginals = true
                print("in on appear plz only print once")
                origLookUp = lookUpSens
                origLookDown = lookDownSens
                origLookLeft = lookLeftSens
                origLookRight = lookRightSens
            }
        }
        .onChange(of: inCalibrationConfirmation) {_ in
            makeSound()
        }
        .onChange(of: calibrationState) { _ in
            makeSound()
        }
    }
    
    private func makeSound() {
        print("in make sound calib")
        guard let soundURL = Bundle.main.url(forResource: "blinkTone.wav", withExtension: nil) else {
                    fatalError("Unable to find blinkTone.wav in bundle")
            }

            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            } catch {
                print(error.localizedDescription)
            }
            audioPlayer.play()
    }
}

struct CalibrationView_Previews: PreviewProvider {
    static var tempSelect = selectedState(buttonType: ButtonType.settingToggle, buttonId: 0, clickState: 1, isNo: false)
    
    static var previews: some View {
        CalibrationView(state: .constant(7), showConfirmationScreen: .constant(true), selectState: .constant(tempSelect), queue: .constant([]), value: .constant(0), nextStateId: .constant(0), prevState: .constant(7), lookUpSens: .constant(0.7), lookDownSens: .constant(0.35), lookLeftSens: .constant(0.7), lookRightSens: .constant(0.35), blinkSens: .constant(0.9),playSound: .constant(true))
    }
}

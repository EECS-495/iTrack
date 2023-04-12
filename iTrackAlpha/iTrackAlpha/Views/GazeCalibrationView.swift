//
//  GazeCalibrationView.swift
//  iTrackAlpha
//
//  Created by Danielle Maraffino on 4/10/23.
//

import SwiftUI
import AVFoundation

struct GazeCalibrationView: View {
    @Binding var calibrationState: CalibrationState
    @Binding var selectState: selectedState
    @Binding var queue: [Action]
    @Binding var value: Int
    @Binding var lookUpSens: CGFloat // connected to the customization sensitivities
    @Binding var lookDownSens: CGFloat
    @Binding var lookLeftSens: CGFloat
    @Binding var lookRightSens: CGFloat
    @Binding var inCalibrationConfirmation: Bool
    @State var audioPlayer: AVAudioPlayer!
    // TODO determine way of saving original ^^ sensitivities, changing temp versions and updating the ones above only if the user clicks confirm in GazeConfirmationView
    var body: some View {
        Text(calibrationText())
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
    
    private func calibrationText() -> String {
        if calibrationState == CalibrationState.up {
            return "Look up until you hear a sound"
        } else if calibrationState == CalibrationState.down {
            return "Look down until you hear a sound"
        } else if calibrationState == CalibrationState.left {
            return "Look left until you hear a sound"
        } else if calibrationState == CalibrationState.right {
            return "Look right until you hear a sound"
        } else {
            return "This string should never be displayed, invalid calibration state for GazeCalibrationView"
        }
    }
    
    private func registerGaze(action: ActionType) {
        if calibrationState == CalibrationState.up && action == ActionType.up {
            // play sound
            // go to confirmation for that up sensitivity
            //makeSound()
            selectState.buttonId = 0
            selectState.buttonType = ButtonType.calibrationConf
            inCalibrationConfirmation = true
        } else if calibrationState == CalibrationState.down && action == ActionType.down {
            // playSound
            // go to confirmation for that down sensitivity
            //makeSound()
            inCalibrationConfirmation = true
            selectState.buttonId = 0
            selectState.buttonType = ButtonType.calibrationConf
        } else if calibrationState == CalibrationState.left && action == ActionType.left {
            // playSound
            // go to confirmation for that left sensitivity
            //makeSound()
            inCalibrationConfirmation = true
            selectState.buttonId = 0
            selectState.buttonType = ButtonType.calibrationConf
            // possible addition later for go back????
        } else if calibrationState == CalibrationState.right && action == ActionType.right {
            // playSound
            // go to confirmation for that right sensitivity
            //makeSound()
            inCalibrationConfirmation = true
            selectState.buttonId = 0
            selectState.buttonType = ButtonType.calibrationConf
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

struct GazeCalibrationView_Previews: PreviewProvider {
    static var tempSelect = selectedState(buttonType: ButtonType.calibration, buttonId: 0, clickState: 1, isNo: false)
    
    static var previews: some View {
        GazeCalibrationView(calibrationState: .constant(CalibrationState.up), selectState: .constant(tempSelect), queue: .constant([]), value: .constant(0), lookUpSens: .constant(0.7), lookDownSens: .constant(0.35), lookLeftSens: .constant(0.7), lookRightSens: .constant(0.7), inCalibrationConfirmation: .constant(false))
    }
}

//
//  ViewController.swift
//  iTrackAlpha
//
//  Created by Manan Manchanda on 2/10/23.
//

import UIKit
import ARKit
import SwiftUI



class ViewController: UIViewController, ARSCNViewDelegate {
    var sceneView: ARSCNView!
    let viewModel = ViewModel()
    // var contentView: UIHostingController(rootView: ContentView(viewModel: viewModel))
    var actionDelay = false
    var blinkDelayTime = 1.0
    var lookDelayTime = 1.0
    var blinkSens = 0.9
    var lookUpSens = 0.7
    var lookDownSens = 0.35
    var lookLeftSens = 0.7
    var lookRightSens = 0.7
    var eyeDetect = EyeDetect.both
    @ObservedObject var customizations = CustomizationObject()
    
    /*var upDelay = false
    var downDelay = false
    var rightDelay = false
    var leftDelay = false*/

    override func viewDidLoad() {
    
        
        UIApplication.shared.isIdleTimerDisabled = true
        super.viewDidLoad()
        /*
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        var denied = false
        
        switch authorizationStatus {
        case .authorized:
            // do nothing, already granted
             break
        case .notDetermined:
            // Request camera access
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    // do nothing, already granted
                } else {
                    denied = true
                }
            }
        case .denied, .restricted:
            denied = true
            
        if denied
        {
            fatalError("Face tracking is not supported on this device")
        }
        
        @unknown default:
            fatalError("Unexpected case of AVCaptureDevice.authorizationStatus")
        }
        */
        
        
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face tracking is not supported on this device")
        }
        sceneView = ARSCNView(frame: self.view.frame)
        sceneView.delegate = self
        sceneView.backgroundColor = UIColor.white
        self.view.addSubview(sceneView)
        let contentView = UIHostingController(rootView: ContentView(viewModel: self.viewModel, lastAction: "none", customizations: self.customizations))
        addChild(contentView)
        view.addSubview(contentView.view)
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true

        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        sceneView.session.pause()
    }
    
//    fileprivate func setupConstraints(contentView: ) {
//        contentView.view.translatesAutoresizingMaskIntoConstraints = false
//        contentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        contentView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        contentView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else {
            print("Anchor is not a face anchor")
            return
        }

        var leftBlink = faceAnchor.blendShapes[.eyeBlinkLeft]?.doubleValue ?? 0
        var rightBlink = faceAnchor.blendShapes[.eyeBlinkRight]?.doubleValue ?? 0

        var lookUpLeft = faceAnchor.blendShapes[.eyeLookUpLeft]?.doubleValue ?? 0
        var lookUpRight = faceAnchor.blendShapes[.eyeLookUpRight]?.doubleValue ?? 0
        
        var lookDownLeft = faceAnchor.blendShapes[.eyeLookDownLeft]?.doubleValue ?? 0
        var lookDownRight = faceAnchor.blendShapes[.eyeLookDownRight]?.doubleValue ?? 0
        
        var lookLeftLeft = faceAnchor.blendShapes[.eyeLookInLeft]?.doubleValue ?? 0
        var lookLeftRight = faceAnchor.blendShapes[.eyeLookOutRight]?.doubleValue ?? 0
        
        var lookRightLeft = faceAnchor.blendShapes[.eyeLookOutLeft]?.doubleValue ?? 0
        var lookRightRight = faceAnchor.blendShapes[.eyeLookInRight]?.doubleValue ?? 0
        
        let mouthOpen = faceAnchor.blendShapes[.jawOpen]?.doubleValue ?? 0
        
        if eyeDetect == EyeDetect.right
        {
            leftBlink = 1
            lookUpLeft = 1
            lookDownLeft = 1
            lookLeftLeft = 1
            lookRightLeft = 1
        }
        else if eyeDetect == EyeDetect.left
        {
            rightBlink = 1
            lookUpRight = 1
            lookDownRight = 1
            lookLeftRight = 1
            lookRightRight = 1
        }
        
        blinkDelayTime = customizations.longerBlinkDelay ? 2.0 : 1.0
        lookDelayTime = customizations.longerGazeDelay ? 2.0 : 1.0
        blinkSens = customizations.blinkSens
        lookUpSens = customizations.lookUpSens
        lookDownSens = customizations.lookDownSens
        lookRightSens = customizations.lookRightSens
        lookLeftSens = customizations.lookLeftSens
        
        if !actionDelay {
            if leftBlink > blinkSens && rightBlink > blinkSens {
                print("Blink")
                viewModel.push(action: Action(actionType: ActionType.blink))
                self.actionDelay = true
                DispatchQueue.main.asyncAfter(deadline: .now() + blinkDelayTime){
                    self.actionDelay = false
                }
            }

            if lookUpLeft > lookUpSens && lookUpRight > lookUpSens {
                print("Up")
                viewModel.push(action: Action(actionType: ActionType.up))
                self.actionDelay = true
                DispatchQueue.main.asyncAfter(deadline: .now() + lookDelayTime){
                    self.actionDelay = false
                }
            }
            if lookDownLeft > lookDownSens && lookDownRight > lookDownSens {
                print("Down")
                viewModel.push(action: Action(actionType: ActionType.down))
                self.actionDelay = true
                DispatchQueue.main.asyncAfter(deadline: .now() + lookDelayTime){
                    self.actionDelay = false
                }
            }
            if lookLeftLeft > lookLeftSens && lookLeftRight > lookLeftSens  {
                print("Left")
                viewModel.push(action: Action(actionType: ActionType.left))
                self.actionDelay = true
                DispatchQueue.main.asyncAfter(deadline: .now() + lookDelayTime){
                    self.actionDelay = false
                }
            }
            if lookRightLeft > lookRightSens && lookRightRight > lookRightSens {
                print("Right")
                viewModel.push(action: Action(actionType: ActionType.right))
                self.actionDelay = true
                DispatchQueue.main.asyncAfter(deadline: .now() + lookDelayTime){
                    self.actionDelay = false
                }
            }
            if mouthOpen > 0.5
            {
                print("Mouth Open")
                //ACTION
                self.actionDelay = true
                DispatchQueue.main.asyncAfter(deadline: .now() + lookDelayTime){
                    self.actionDelay = false
                }
            }
        }
        
    }

}

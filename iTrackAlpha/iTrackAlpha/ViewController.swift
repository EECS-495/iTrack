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
    @ObservedObject var customizations = CustomizationObject()
    
    /*var upDelay = false
    var downDelay = false
    var rightDelay = false
    var leftDelay = false*/

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

        let leftBlink = faceAnchor.blendShapes[.eyeBlinkLeft]?.doubleValue ?? 0
        let rightBlink = faceAnchor.blendShapes[.eyeBlinkRight]?.doubleValue ?? 0

        let lookUpLeft = faceAnchor.blendShapes[.eyeLookUpLeft]?.doubleValue ?? 0
        let lookUpRight = faceAnchor.blendShapes[.eyeLookUpRight]?.doubleValue ?? 0
        
        let lookDownLeft = faceAnchor.blendShapes[.eyeLookDownLeft]?.doubleValue ?? 0
        let lookDownRight = faceAnchor.blendShapes[.eyeLookDownRight]?.doubleValue ?? 0
        
        let lookLeftLeft = faceAnchor.blendShapes[.eyeLookInLeft]?.doubleValue ?? 0
        let lookLeftRight = faceAnchor.blendShapes[.eyeLookOutRight]?.doubleValue ?? 0
        
        let lookRightLeft = faceAnchor.blendShapes[.eyeLookOutLeft]?.doubleValue ?? 0
        let lookRightRight = faceAnchor.blendShapes[.eyeLookInRight]?.doubleValue ?? 0
        
        let mouthOpen = faceAnchor.blendShapes[.jawOpen]?.doubleValue ?? 0
        
        blinkDelayTime = customizations.longerBlinkDelay ? 2.0 : 1.0
        lookDelayTime = customizations.longerGazeDelay ? 2.0 : 1.0
        if !actionDelay {
            if leftBlink > 0.9 && rightBlink > 0.9 {
                print("Blink")
                print("blink delay \(blinkDelayTime)")
                print("gaze delay \(lookDelayTime)")
                viewModel.push(action: Action(actionType: ActionType.blink))
                self.actionDelay = true
                DispatchQueue.main.asyncAfter(deadline: .now() + blinkDelayTime){
                    self.actionDelay = false
                }
                
            }
            if lookUpLeft > 0.7 && lookUpRight > 0.7 {
                print("Up")
                viewModel.push(action: Action(actionType: ActionType.up))
                self.actionDelay = true
                DispatchQueue.main.asyncAfter(deadline: .now() + lookDelayTime){
                    self.actionDelay = false
                }
            }
            if lookDownLeft > 0.35 && lookDownRight > 0.35 {
                print("Down")
                viewModel.push(action: Action(actionType: ActionType.down))
                self.actionDelay = true
                DispatchQueue.main.asyncAfter(deadline: .now() + lookDelayTime){
                    self.actionDelay = false
                }
            }
            if lookLeftLeft > 0.7 && lookLeftRight > 0.7  {
                print("Left")
                viewModel.push(action: Action(actionType: ActionType.left))
                self.actionDelay = true
                DispatchQueue.main.asyncAfter(deadline: .now() + lookDelayTime){
                    self.actionDelay = false
                }
            }
            if lookRightLeft > 0.7 && lookRightRight > 0.7 {
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

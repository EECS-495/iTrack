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
    let contentView = UIHostingController(rootView: ContentView())
    var blinkDelay = false
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
        
        addChild(contentView)
        view.addSubview(contentView.view)
        setupConstraints()
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
    
    fileprivate func setupConstraints() {
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
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
        
        
        if leftBlink > 0.9 && rightBlink > 0.9 && !self.blinkDelay {
            print("Blink")
            self.blinkDelay = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                self.blinkDelay = false
            }
            
        }
        if lookUpLeft > 0.7 && lookUpRight > 0.7 && !self.blinkDelay {
            print("Up")
        }
        if lookDownLeft > 0.35 && lookDownRight > 0.35 && !self.blinkDelay {
            print("Down")
        }
        if lookLeftLeft > 0.7 && lookLeftRight > 0.7 && !self.blinkDelay {
            print("Left")
        }
        if lookRightLeft > 0.7 && lookRightRight > 0.7 && !self.blinkDelay {
            print("Right")
        }
    }

}

//
//  ViewController.swift
//  iTrackAlpha
//
//  Created by Manan Manchanda on 2/10/23.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    var sceneView: ARSCNView!

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true

        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else {
            print("Anchor is not a face anchor")
            return
        }

        // Check if the user has blinked by checking the value of the "eyeBlinkLeft" or "eyeBlinkRight" blend shape
        let leftBlink = faceAnchor.blendShapes[.eyeBlinkLeft]?.doubleValue ?? 0
        let rightBlink = faceAnchor.blendShapes[.eyeBlinkRight]?.doubleValue ?? 0

        if leftBlink > 0.9 || rightBlink > 0.9 {
            print("blink")
        }
    }

}

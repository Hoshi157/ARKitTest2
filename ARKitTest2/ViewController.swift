//
//  ViewController.swift
//  ARKitTest2
//
//  Created by 福山帆士 on 2020/07/06.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
// この方法はARAnchorは環境に紐付いた情報なので共有される場合などに適している。
class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(Tap))
        sceneView.addGestureRecognizer(gesture)
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @objc func Tap(sender: UITapGestureRecognizer) {
        let position = sender.location(in: sceneView)
        let results = sceneView.hitTest(position, types: .featurePoint) // sceneViewのhitTestを取得
        if !results.isEmpty {
            // ARAnchorはobjectを配置するための位置・方向などを持ったオブジェクト
            let anchor = ARAnchor(name: "shipAnchor", transform: results.first!.worldTransform)
            sceneView.session.add(anchor: anchor)
        }
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    // ARAnchor生成時に呼ばれる
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor.name == "shipAnchor" {
            guard let scene = SCNScene(named: "ship.scn", inDirectory: "art.scnassets") else {
                return
            }
            let shipNode = scene.rootNode.childNode(withName: "ship", recursively: false)!
            node.addChildNode(shipNode)
            // ARAnchor上にshipNodeを配置する
        }
    }
}

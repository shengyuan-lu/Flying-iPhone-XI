// Test iPhone XI Flying Feature
// Shengyuan Lu's playground for WWDC19 scholarship

//: NOTE This playground contains sound files. Unmute the device for better experience.

//: NOTE Use LiveView!

//: NOTE There is a "Credit and Explanation" document inside Source folder.


import PlaygroundSupport
import SpriteKit
import UIKit

// Load font
let fontURL = Bundle.main.url(forResource: "BebasNeue-Regular", withExtension: "ttf")
CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)

// Load the SKScene from 'WelcomeScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
sceneView.showsNodeCount = false
sceneView.showsFPS = false

// Set scene one
if let sceneOne = WelcomeScene(fileNamed: "WelcomeScene") {
    // Set the scale mode to scale to fit the window
    sceneOne.scaleMode = .aspectFill
    sceneOne.anchorPoint = CGPoint.zero
    
    // Present the scene
    sceneView.presentScene(sceneOne)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView



import Foundation
import SpriteKit

public class aboutScene: SKScene {
    
    // About image
    let about = SKSpriteNode(imageNamed: "about")
    
    // Animations
    let moveUp = SKAction.moveTo(y: 0, duration: 1.0)
    let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
    
    // Sound
    var click = SKAction.playSoundFileNamed("Click.wav", waitForCompletion: false)
    
    // Emitter
    let emitter = SKEmitterNode(fileNamed: "Dust")
    func addDustEmitter(){
        self.emitter?.zPosition = 1
        self.emitter?.particleScaleRange = 0.07
        self.emitter?.emissionAngle = -180
        self.emitter?.position = CGPoint(x: size.width/2, y: size.height)
        self.addChild(emitter!)
    }
    
    public override func didMove(to view: SKView) {
        about.anchorPoint = CGPoint.zero
        about.position = CGPoint(x: 0, y: -size.height)
        about.size = CGSize(width: size.width, height: size.height)
        about.alpha = 0
        about.run(moveUp)
        about.run(fadeIn)
        about.zPosition = 2
        addChild(about)
        self.addDustEmitter()
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       self.run(click)
        // Set scene one
        if let sceneOne = WelcomeScene(fileNamed: "WelcomeScene") {
            // Set the scale mode to scale to fit the window
            sceneOne.scaleMode = .aspectFill
            sceneOne.anchorPoint = CGPoint.zero
            
            // Present the scene
            self.view?.presentScene(sceneOne, transition: SKTransition.crossFade(withDuration: 2.0))
        }

    }
    
}


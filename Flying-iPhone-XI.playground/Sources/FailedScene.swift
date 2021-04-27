import Foundation
import SpriteKit

public class FailedScene: SKScene {
    
    // Button
    let continueButtonLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-Bold")
    let continueButton = SKSpriteNode(imageNamed: "continueButton")
    
    // Foreground
    let foreground = SKSpriteNode(imageNamed: "fail")
    
    // Sound
    let click = SKAction.playSoundFileNamed("Click.wav", waitForCompletion: false)
    let fail = SKAction.playSoundFileNamed("lose.wav", waitForCompletion: false)
    
    // Animation
    let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
    let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 1.0)
    let moveDown = SKAction.moveBy(x: 0, y: -100, duration: 1.0)
    
    public override func didMove(to view: SKView) {
        
        self.run(fail)
        
        // Foreground
        foreground.anchorPoint = CGPoint.zero
        foreground.position = CGPoint.zero
        foreground.size = CGSize(width: size.width, height: size.height)
        foreground.alpha = 0
        self.addChild(self.foreground)
        self.foreground.run(self.fadeIn)
        
        // Add Button
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.continueButton.position = CGPoint(x: 25, y: 25)
            self.continueButton.anchorPoint = CGPoint.zero
            self.continueButton.size = CGSize(width: 250, height: 50)
            self.continueButton.alpha = 0.0
            self.addChild(self.continueButton)
            self.continueButton.run(self.fadeIn)
            
            // Set button label
            self.continueButtonLabel.color = SKColor.white
            self.continueButtonLabel.text = "Try again"
            self.continueButtonLabel.fontSize = 26
            self.continueButtonLabel.horizontalAlignmentMode = .center
            self.continueButtonLabel.alpha = 0
            self.continueButtonLabel.zPosition = 100
            self.continueButtonLabel.position = CGPoint(x: 150, y: 40)
            self.addChild(self.continueButtonLabel)
            self.continueButtonLabel.run(self.fadeIn)
        }
        
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if continueButton.contains(location) {
                
                self.run(click)
                self.foreground.run(fadeOut)
                self.continueButton.run(fadeOut)
                self.continueButton.run(moveDown)
                self.continueButtonLabel.run(fadeOut)
                self.continueButtonLabel.run(moveDown)
                self.continueButton.texture = SKTexture(imageNamed: "continueButtonGrey")
                
                // Delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    // Create scene three
                    let sceneThree = GameScene(fileNamed: "GameScene")
                    sceneThree?.scaleMode = .aspectFill
                    sceneThree?.anchorPoint = CGPoint.zero
                    
                    // Change scene
                    self.view?.presentScene(sceneThree!, transition: SKTransition.crossFade(withDuration: 1.0))
                }
            }
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.continueButton.texture = SKTexture(imageNamed: "continueButton")
        }
    }
    
}

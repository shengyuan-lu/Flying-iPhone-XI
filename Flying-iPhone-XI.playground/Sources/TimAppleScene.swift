import PlaygroundSupport
import SpriteKit
import AVFoundation
import Foundation

public class TimAppleScene: SKScene {
    // initial setup
    var numberTouched:Int = 0
    let timApple = SKSpriteNode(imageNamed: "tim1")
    let continueButton = SKSpriteNode(imageNamed: "continueButton")
    let continueButtonLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-Bold")
    let bubble = SKSpriteNode(imageNamed: "bubble1")
    
    // Sound
    var click = SKAction.playSoundFileNamed("Click.wav", waitForCompletion: false)
    var hi = AVPlayer(url: Bundle.main.url(forResource: "Hi", withExtension: "m4a")!)
    var newEngineer = AVPlayer(url: Bundle.main.url(forResource: "New Engineer", withExtension: "m4a")!)
    var firstTask = AVPlayer(url: Bundle.main.url(forResource: "First Task", withExtension: "m4a")!)
    var fireYou = AVPlayer(url: Bundle.main.url(forResource: "Fire You", withExtension: "m4a")!)
    
    // Animations
    let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
    let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 1.0)
    let bubbleFadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.5)
    
    
    
    public override func didMove(to view: SKView) {
        
        // Tim Apple
        timApple.anchorPoint = CGPoint.zero
        var timTexturesOne:[SKTexture] = []
        for i in 1...2 {
            timTexturesOne.append(SKTexture(imageNamed: "tim\(i)"))
        }
        let timAnimationOne: SKAction!
        timAnimationOne = SKAction.animate(with: timTexturesOne, timePerFrame: 0.5)
        timApple.run(SKAction.repeatForever(timAnimationOne))
        timApple.alpha = 0.0
        timApple.size = CGSize(width: 640, height: 480)
        timApple.position = CGPoint(x: 0, y: 0)
        addChild(timApple)
        
        
        // continue Button
        continueButton.anchorPoint = CGPoint.zero
        continueButton.position = CGPoint(x: 40, y: 25)
        continueButton.alpha = 0.0
        self.continueButton.size = CGSize(width: 250, height: 50)
        self.continueButton.run(self.bubbleFadeIn)
        addChild(continueButton)
        
        // continue Button label
        continueButtonLabel.color = SKColor.white
        continueButtonLabel.text = "Hi, Tim! 👋🏻"
        continueButtonLabel.fontSize = 26
        continueButtonLabel.horizontalAlignmentMode = .center
        continueButtonLabel.alpha = 0
        continueButtonLabel.zPosition = 100
        continueButtonLabel.position = CGPoint(x: 165, y: 40)
        self.continueButtonLabel.run(self.bubbleFadeIn)
        addChild(continueButtonLabel)
        
        // bubble
        bubble.anchorPoint = CGPoint.zero
        bubble.position = CGPoint(x: 25, y: 220)
        bubble.alpha = 0.0
        bubble.size = CGSize(width: 300, height: 235)
        addChild(bubble)
        bubble.run(bubbleFadeIn)
        
        // Tim Apple
        timApple.run(bubbleFadeIn)
        
        // Sound
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.hi.play()
        }
        
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if continueButton.contains(location) {
                if numberTouched == 0 {
                    // Sound
                    run(click)
                    
                    // button texture
                    continueButton.texture = SKTexture(imageNamed: "continueButtonGrey")
                    
                    // bubble texture
                    bubble.texture = SKTexture(imageNamed: "bubble2")
                    
                    // Sound
                    self.hi.pause()
                    self.newEngineer.play()
                    
                    // track number touched
                    numberTouched += 1
                    
                    // Additional Tim Apple Texture
                    var timTexturesTwo:[SKTexture] = []
                    for i in 3...4 {
                        timTexturesTwo.append(SKTexture(imageNamed: "tim\(i)"))
                    }
                    let timAnimationTwo: SKAction!
                    timAnimationTwo = SKAction.animate(with: timTexturesTwo, timePerFrame: 0.5)
                    timApple.run(SKAction.repeatForever(timAnimationTwo))
                    
                    // Update button label
                    self.continueButtonLabel.text = "Yes, I am! ⚙️"
                    
                    
                } else if numberTouched == 1 {
                    // Sound
                    run(click)
                    
                    // button texture
                    continueButton.texture = SKTexture(imageNamed: "continueButtonGrey")
                    
                    // bubble texture
                    bubble.texture = SKTexture(imageNamed: "bubble3")
                    
                    // Sound
                    self.firstTask.play()
                    self.newEngineer.pause()
                    
                    // track number touched
                    numberTouched += 1
                    
                    // Additional Tim Apple Texture
                    var timTexturesThree:[SKTexture] = []
                    for i in 5...6 {
                        timTexturesThree.append(SKTexture(imageNamed: "tim\(i)"))
                    }
                    let timAnimationThree: SKAction!
                    timAnimationThree = SKAction.animate(with: timTexturesThree, timePerFrame: 0.5)
                    timApple.run(SKAction.repeatForever(timAnimationThree))
                    
                    // Update button label
                    self.continueButtonLabel.text = "I am ready! ✈️"
                    
                    
                } else if numberTouched == 2 {
                    // Sound
                    run(click)
                    
                    // button texture
                    continueButton.texture = SKTexture(imageNamed: "continueButtonGrey")
                    
                    // bubble texture
                    bubble.texture = SKTexture(imageNamed: "bubble4")
                    
                    // Sound
                    self.firstTask.pause()
                    self.fireYou.play()
                    
                    // track number touched
                    numberTouched += 1
                    
                    // Additional Tim Apple Texture
                    var timTexturesFour:[SKTexture] = []
                    for i in 7...8 {
                        timTexturesFour.append(SKTexture(imageNamed: "tim\(i)"))
                    }
                    let timAnimationFour: SKAction!
                    timAnimationFour = SKAction.animate(with: timTexturesFour, timePerFrame: 0.5)
                    timApple.run(SKAction.repeatForever(timAnimationFour))
                    
                    // Update button label
                    self.continueButtonLabel.text = "Yes boss! 👨🏼‍💻"

                    
                } else if numberTouched == 3 {
                    // Sound
                    run(click)
                    
                    // Quit Animation
                    let timAppleDown = SKAction.moveBy(x: 0, y: -500, duration: 1.5)
                    timApple.run(timAppleDown)
                    timApple.run(fadeOut)
                    continueButton.run(fadeOut)
                    continueButtonLabel.run(fadeOut)
                    bubble.run(fadeOut)
                    
                    // Delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    // Create scene three
                    let sceneThree = GameScene(fileNamed: "GameScene")
                    sceneThree?.scaleMode = .aspectFill
                    sceneThree?.anchorPoint = CGPoint.zero
        
                    // Change scene
                    self.view?.presentScene(sceneThree!, transition: SKTransition.crossFade(withDuration: 2.0))
                    }
                    
                    
            } // End of else if
            } // End of if
            
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.continueButton.texture = SKTexture(imageNamed: "continueButton")
        }
    }
    
}

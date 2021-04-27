import PlaygroundSupport
import SpriteKit

// WelcomeScene
public class WelcomeScene: SKScene {
    
    private var iPhone: SKSpriteNode!
    private var titleOne: SKLabelNode!
    
    // Number Touched
    var numberTouched:Int = 0
    
    // Sound
    var droneSound: SKAudioNode!
    var click = SKAction.playSoundFileNamed("Click.wav", waitForCompletion: false)
    
    // Animations
    let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
    let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 1.0)
    let moveDown = SKAction.moveTo(y: -50, duration: 1.0)
    
    // Continue Button
    let continueButton = SKSpriteNode(imageNamed: "continueButton")
    
    // Continue Button Label
    let continueButtonLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-Bold")
    
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
        
        // Link
        iPhone = childNode(withName: "flyingPhone") as? SKSpriteNode
        iPhone.size = CGSize(width: 320, height: 240)
        iPhone.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        iPhone.position = CGPoint(x: 320, y: -120)
        iPhone.zPosition = 2
        
        titleOne = childNode(withName: "titleOne") as? SKLabelNode
        titleOne.horizontalAlignmentMode = .center
        titleOne.position = CGPoint(x: 320, y: 100)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Add Button
            self.continueButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            self.continueButton.position = CGPoint(x: self.size.width/2, y: 50)
            self.continueButton.alpha = 0.0
            self.continueButton.zPosition = 3
            self.continueButton.size = CGSize(width: 250, height: 50)
            self.addChild(self.continueButton)
            self.addChild(self.continueButtonLabel)
        }
        
        // Sound
        if let musicURL = Bundle.main.url(forResource: "Drone Sound", withExtension: "wav") {
            droneSound = SKAudioNode(url: musicURL)
            addChild(droneSound)
        }
        
        // Change Volume
        self.droneSound.run(SKAction.changeVolume(to: 0.5, duration: 0.5))
        
        
        // Set flying phone alpha
        iPhone.alpha = 0.0
        
        // iPhone animation One
        let iPhoneAnimationOne: SKAction!
        var textures:[SKTexture] = []
        for i in 0...1 {
            textures.append(SKTexture(imageNamed: "iPhone\(i)"))
        }
        
        iPhoneAnimationOne = SKAction.animate(with: textures, timePerFrame: 0.1)
        iPhone.run(SKAction.repeatForever(iPhoneAnimationOne))
        
        // iPhone animation Two
        let iPhoneAnimationTwo = SKAction.fadeAlpha(to: 1.0, duration: 2.0)
        iPhone.run(iPhoneAnimationTwo)
        
        // iPhone animation Three
        let iPhoneAnimationThree = SKAction.moveTo(y: 300, duration: 1.5)
        iPhone.run(iPhoneAnimationThree)
        
        // Title alpha properties
        titleOne.alpha = 0.0
        
        // add emitter
        self.addDustEmitter()
        
        // Set button label
        continueButtonLabel.color = SKColor.white
        continueButtonLabel.text = "Start!"
        continueButtonLabel.fontSize = 26
        continueButtonLabel.horizontalAlignmentMode = .center
        continueButtonLabel.alpha = 0
        continueButtonLabel.zPosition = 100
        continueButtonLabel.position = CGPoint(x: self.size.width/2, y: 40)
        
        // Add button
        continueButtonLabel.run(fadeIn)
        continueButton.run(fadeIn)
    }
    
    // Handle touches
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Tap on countinueButton
        for touch in touches {
            let location = touch.location(in: self)
            if continueButton.contains(location) {
                if numberTouched == 0 {
                    // Sound
                    run(click)
                    // Change titleOne font
                    titleOne.fontName = "BebasNeue-Regular"
                    // titleOne animation
                    titleOne.run(fadeIn)
                    
                    // Change texture
                    continueButton.texture = SKTexture(imageNamed: "continueButtonGrey")
                    // track number touched
                    numberTouched += 1
                    
                    // Change button label text
                    self.continueButtonLabel.text = "Continue"
                    
                } else if numberTouched == 1 {
                    // Sound
                    run(click)
                    
                    // Change texture
                    continueButton.texture = SKTexture(imageNamed: "continueButtonGrey")
                    
                    // Move up iPhone
                    let iPhoneAnimationThree = SKAction.moveBy(x: 0, y: 400, duration: 1.1)
                    iPhone.run(iPhoneAnimationThree)
                    
                    titleOne.run(fadeOut)
                    continueButton.run(fadeOut)
                    continueButton.run(moveDown)
                    emitter?.run(fadeOut)
                    continueButtonLabel.run(fadeOut)
                    continueButtonLabel.run(moveDown)
                    self.droneSound.run(SKAction.changeVolume(to: 0, duration: 1.0))
                    
                    // track number touched
                    numberTouched += 1
                    
                    // Delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        // Change Scene
                        // Create sceneTwo
                        let sceneTwo = TimAppleScene(fileNamed: "TimAppleScene")
                        sceneTwo?.scaleMode = .aspectFill
                        sceneTwo?.anchorPoint = CGPoint.zero
                        // Set the scale mode to scale to fit the window
                        
                        self.view?.presentScene(sceneTwo!, transition: SKTransition.crossFade(withDuration: 1.2))
                    }
                    
                } else {
                    titleOne.alpha = 0.0
                    
                }
            }
            
        }
    } // End of touchBegin
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Change texture
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.continueButton.texture = SKTexture(imageNamed: "continueButton")
        }
    }
    
} // End of Class

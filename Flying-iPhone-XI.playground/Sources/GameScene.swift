import PlaygroundSupport
import SpriteKit

public class GameScene:SKScene {
    
    // Track number touched
    var numberTouched = 0
    
    // Set iPhone movement data
    let iPhoneMovePointsPerSec: CGFloat = 480
    var velocity = CGPoint.zero
    
    // Lives remaining
    var liveCount = 5
    
    // Phototaken count
    var photoTakenCount = 0
    var numberOfPhotoSpawned = 0
    
    
    // Set up
    let instructionLabel = SKLabelNode(fontNamed: "BebasNeue-Regular")
    let instructionText = SKLabelNode()
    let instructionTextTwo = SKLabelNode()
    let instructionTextThree = SKLabelNode()
    let livesLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-Medium")
    let photoTakenLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-Medium")
    let continueButton = SKSpriteNode(imageNamed: "continueButton")
    let iPhone = SKSpriteNode(imageNamed: "iPhone0")
    let background = SKSpriteNode(imageNamed: "background1")
    let continueButtonLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-Bold")
    let photoFlash = SKSpriteNode()
    
    // Sound
    let click = SKAction.playSoundFileNamed("Click.wav", waitForCompletion: false)
    let bump = SKAction.playSoundFileNamed("Bump.wav", waitForCompletion: false)
    let birdSound = SKAction.playSoundFileNamed("birdSound.wav", waitForCompletion: false)
    var droneSound: SKAudioNode!
    let photoSound = SKAction.playSoundFileNamed("Take Photo.wav", waitForCompletion: false)
    
    // Animations
    let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
    let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 1.0)
    let moveDown = SKAction.move(to: CGPoint(x: 320, y: -100), duration: 1.0)
    let moveUp = SKAction.move(to: CGPoint(x: 320, y: 700), duration: 1.0)
    let BGmoveUp = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 1.0)
    var iPhoneAnimationOne: SKAction!
    
    // Flash sequence
    func flash(node:SKNode, alpha:CGFloat) {
        let one = SKAction.fadeAlpha(to: alpha, duration: 0.1)
        let wait = SKAction.wait(forDuration: 0.05)
        let two = SKAction.fadeAlpha(to: 1, duration: 0.1)
        let sequence = SKAction.sequence([one, wait, two])
        node.run(sequence)
    }
    
    func flashInverse(node:SKNode) {
        let one = SKAction.fadeAlpha(to: 0.8, duration: 0.1)
        let wait = SKAction.wait(forDuration: 0.05)
        let two = SKAction.fadeAlpha(to: 0, duration: 0.1)
        let sequence = SKAction.sequence([one, wait, two])
        node.run(sequence)
    }
    
    
    // Actual move function
    func move(sprite: SKSpriteNode, velocity: CGPoint) {
        // Get amount to move
        let amountToMove = CGPoint(x: velocity.x * CGFloat(0.01), y: velocity.y * CGFloat(0.01))
        
        // Change Sprite Position
        sprite.position = CGPoint(
            x: sprite.position.x + amountToMove.x,
            y: sprite.position.y + amountToMove.y)
    }
    
    
    func moveiPhoneToward(location: CGPoint) {
        
        // Calculate offset
        let offset = CGPoint(x: location.x - iPhone.position.x,
                             y: location.y - iPhone.position.y)
        
        // Square root to find length
        let length = sqrt(
            Double(offset.x * offset.x + offset.y * offset.y))
        
        // Get direction
        let direction = CGPoint(x: offset.x / CGFloat(length),
                                y: offset.y / CGFloat(length))
        
        velocity = CGPoint(x: direction.x * iPhoneMovePointsPerSec,
                           y: direction.y * iPhoneMovePointsPerSec)
    }
    
    // sceneTouched function
    func sceneTouched(touchLocation:CGPoint) {
        moveiPhoneToward(location: touchLocation)
    }
    
    // Check if iPhone reaches bound
    func boundsCheckiPhone() {
        let bottomLeft = CGPoint(x: iPhone.size.width/2, y: iPhone.size.height/2)
        let topRight = CGPoint(x: (size.width-iPhone.size.width/2), y: (size.height-iPhone.size.height/2))
        
        if iPhone.position.x <= bottomLeft.x {
            iPhone.position.x = bottomLeft.x
            velocity.x = -velocity.x
            run(bump)
        }
        if iPhone.position.x >= topRight.x {
            iPhone.position.x = topRight.x
            velocity.x = -velocity.x
            run(bump)
        }
        if iPhone.position.y <= bottomLeft.y {
            iPhone.position.y = bottomLeft.y
            velocity.y = -velocity.y
            run(bump)
        }
        if iPhone.position.y >= topRight.y {
            iPhone.position.y = topRight.y
            velocity.y = -velocity.y
            run(bump)
        }
    }
    
    // Spawn bird
    func spawnBird() {
        let bird = SKSpriteNode(imageNamed: "bird")
        bird.name = "bird"
        
        // Bird Spawn Y location
        let yNumber = CGFloat.random(min: 40, max: 400)
        
        // Position
        bird.position = CGPoint(x: size.width + bird.size.width/2, y: yNumber)
        
        
        // Size
        bird.size = CGSize(width: 80, height: 80)
        
        // Add bird
        addChild(bird)
        
        // Bird move across the screen
        let actionMove = SKAction.move(
            to: CGPoint(x: -bird.size.width/2, y: yNumber),
            duration: 6.0)
        // Remove bird
        let actionRemove = SKAction.removeFromParent()
        
        bird.run(SKAction.sequence([actionMove, actionRemove]))
    }
    
    // Random Location
    func randomLocation() ->CGPoint {
        
        var xNumber = CGFloat.random(min: 40, max: 600)
        var yNumber = CGFloat.random(min: 40, max: 440)
        var point = CGPoint(x: xNumber, y: yNumber)
        
        while Int(abs(self.iPhone.position.x - xNumber)) < Int(100) || Int(abs(self.iPhone.position.y - yNumber)) < 100 {
            xNumber = CGFloat.random(min: 40, max: 600)
            yNumber = CGFloat.random(min: 40, max: 440)
            point = CGPoint(x: xNumber, y: yNumber)
        }
        
        return point
    }
    
    // Spawn photo
    func spawnPhoto() {
        let photo = SKSpriteNode(imageNamed: "photo")
        photo.name = "photo"
        
        photo.size = CGSize(width: 60, height: 60)
        photo.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    
        photo.position = randomLocation()
        photo.zPosition = 5000
        photo.alpha = 0
        addChild(photo)
        // Add number of photo spawned
        self.numberOfPhotoSpawned += 1
        photo.run(fadeIn)
    }
    
    // Remove hit node
    func iPhoneHit(node: SKSpriteNode) {
        node.removeFromParent()
    }
    // Collision Detection
    func checkCollisions() {
        
        var hitBirds: [SKSpriteNode] = []
        enumerateChildNodes(withName: "bird") { node, _ in
            let bird = node as! SKSpriteNode
            if node.frame.insetBy(dx: 20, dy: 20).intersects(self.iPhone.frame) {
                hitBirds.append(bird)
            }
        }
        for bird in hitBirds{
            // Remove hit bird
            iPhoneHit(node: bird)
            // Hit sound
            self.run(self.birdSound)
            // Deduct livecount
            self.liveCount -= 1
            // Flash
            self.flash(node: livesLabel, alpha: 0.1)
            // Emitter
            self.addExplodeEmitter(point: bird.position)
        }
        
        var takePhoto: [SKSpriteNode] = []
        enumerateChildNodes(withName: "photo") { node, _ in
            let photo = node as! SKSpriteNode
            if node.frame.insetBy(dx: 20, dy: 20).intersects(self.iPhone.frame) {
                takePhoto.append(photo)
            }
        }
        
        for photo in takePhoto{
            // Remove hit bird
            iPhoneHit(node: photo)
            // Taken sound
            self.run(photoSound)
            // Deduct livecount
            self.photoTakenCount += 1
            // Flash
            self.flashInverse(node: photoFlash)
        }
    }
    
    // Emitter
    func addDustEmitter(){
        let emitter = SKEmitterNode(fileNamed: "Dust")
        emitter?.zPosition = -2
        emitter?.position = CGPoint(x: size.width/2, y: size.height)
        addChild(emitter!)
    }
    
    func addExplodeEmitter(point:CGPoint) {
        let emitter = SKEmitterNode(fileNamed: "Explode")
        emitter?.zPosition = 1000
        emitter?.position = point
        addChild(emitter!)
    }
    
    public override func didMove(to view: SKView) {
        
        // Instruction Label
        instructionLabel.text = "Instructions from Tim Apple"
        instructionLabel.fontColor = SKColor.white
        instructionLabel.fontSize = 50
        instructionLabel.horizontalAlignmentMode = .center
        instructionLabel.verticalAlignmentMode = .bottom
        instructionLabel.position = CGPoint(x: 320, y: 400)
        addChild(instructionLabel)
        
        // Instruction Text
        instructionText.text = "1. Use mouse clicks to control the iPhone"
        instructionText.fontColor = SKColor.white
        instructionText.fontSize = 34
        instructionText.fontName = "AvenirNextCondensed-Medium"
        instructionText.horizontalAlignmentMode = .center
        instructionText.verticalAlignmentMode = .bottom
        instructionText.position = CGPoint(x: 320, y: 300)
        addChild(instructionText)
        
        instructionTextTwo.text = "2. Take 5 pictures of San Jose"
        instructionTextTwo.fontColor = SKColor.white
        instructionTextTwo.fontSize = 34
        instructionTextTwo.fontName = "AvenirNextCondensed-Medium"
        instructionTextTwo.horizontalAlignmentMode = .center
        instructionTextTwo.verticalAlignmentMode = .bottom
        instructionTextTwo.position = CGPoint(x: 320, y: 240)
        addChild(instructionTextTwo)
        
        instructionTextThree.text = "3. Avoid random bird attacks"
        instructionTextThree.fontColor = SKColor.white
        instructionTextThree.fontSize = 34
        instructionTextThree.fontName = "AvenirNextCondensed-Medium"
        instructionTextThree.horizontalAlignmentMode = .center
        instructionTextThree.verticalAlignmentMode = .bottom
        instructionTextThree.position = CGPoint(x: 320, y: 195)
        addChild(instructionTextThree)
        
        // Add Button
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.continueButton.position = CGPoint(x: 320, y: 50)
            self.continueButton.size = CGSize(width: 250, height: 50)
            self.continueButton.alpha = 0.0
            self.addChild(self.continueButton)
            self.continueButton.run(self.fadeIn)
            
            // Set button label
            self.continueButtonLabel.color = SKColor.white
            self.continueButtonLabel.text = "Continue"
            self.continueButtonLabel.fontSize = 26
            self.continueButtonLabel.horizontalAlignmentMode = .center
            self.continueButtonLabel.alpha = 0
            self.continueButtonLabel.zPosition = 100
            self.continueButtonLabel.position = CGPoint(x: self.size.width/2, y: 40)
            self.addChild(self.continueButtonLabel)
            self.continueButtonLabel.run(self.fadeIn)
        }
        
        // Setup iPhone
        iPhone.alpha = 0.0
        iPhone.position = CGPoint(x: 100, y: 240)
        iPhone.size = CGSize(width: 132, height: 99)
        iPhone.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        iPhone.zPosition = 1
        var textures:[SKTexture] = []
        for i in 0...1 {
            textures.append(SKTexture(imageNamed: "iPhone\(i)"))
        }
        iPhoneAnimationOne = SKAction.animate(with: textures, timePerFrame: 0.1)
        iPhone.run(SKAction.repeatForever(iPhoneAnimationOne))
        
        // Background
        background.size = CGSize(width: 640, height: 480)
        background.zPosition = -1
        background.alpha = 0
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint(x:0, y: -480)
        
        // Lives label
        livesLabel.text = "iPhone Lives: 5"
        livesLabel.fontColor = SKColor.white
        livesLabel.fontSize = 30
        livesLabel.horizontalAlignmentMode = .left
        livesLabel.zPosition = 1000
        livesLabel.alpha = 0.0
        livesLabel.position = CGPoint(x: 20, y: 440)
        
        // phototaken label
        photoTakenLabel.text = "Photo Taken: 0/5"
        photoTakenLabel.fontColor = SKColor.white
        photoTakenLabel.fontSize = 30
        photoTakenLabel.horizontalAlignmentMode = .right
        photoTakenLabel.zPosition = 1000
        photoTakenLabel.alpha = 0.0
        photoTakenLabel.position = CGPoint(x: self.size.width - 20, y: 440)
        
        // Photo Flash
        photoFlash.size = CGSize(width: size.width, height: size.height)
        photoFlash.color = SKColor.white
        photoFlash.anchorPoint = CGPoint.zero
        photoFlash.zPosition = 10000
        photoFlash.position = CGPoint.zero
        photoFlash.alpha = 0
        addChild(photoFlash)
        
    }

    
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if continueButton.contains(location) {
                if numberTouched == 0 {
                    // Sound
                    run(click)
                    
                    // Change texture
                    continueButton.texture = SKTexture(imageNamed: "continueButtonGrey")
                    // track number touched
                    numberTouched += 1
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.continueButton.run(self.moveDown)
                        self.continueButtonLabel.run(self.moveDown)
                        self.instructionLabel.run(self.moveUp)
                        self.instructionText.run(self.fadeOut)
                        self.instructionTextTwo.run(self.fadeOut)
                        self.instructionTextThree.run(self.fadeOut)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        // Lives Label
                        self.addChild(self.livesLabel)
                        self.livesLabel.run(self.fadeIn)
                        
                        // Phototaken Label
                        self.addChild(self.photoTakenLabel)
                        self.photoTakenLabel.run(self.fadeIn)
                        
                        // Background
                        self.addChild(self.background)
                        self.background.run(self.BGmoveUp)
                        self.background.run(self.fadeIn)
                        // Add Emitter
                        self.addDustEmitter()
                        
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        // Add iPhone
                        self.addChild(self.iPhone)
                        self.iPhone.run(self.fadeIn)
                       
                        
                        // Sound
                        if let musicURL = Bundle.main.url(forResource: "Drone Sound", withExtension: "wav") {
                            self.droneSound = SKAudioNode(url: musicURL)
                            self.addChild(self.droneSound)
                            
                            // Bird
                            self.run(SKAction.repeatForever(
                                SKAction.sequence([SKAction.run() { [weak self] in
                                    self?.spawnBird()},
                                                   SKAction.wait(forDuration: 1.45)])))
                        }
                        
                        // Photo
                        self.spawnPhoto()
                        
                        // Change Volume
                        self.droneSound.run(SKAction.changeVolume(to: 0.5, duration: 0.0))
                        
                        
                    } // End of delay
                    
                } // End of number Touched
            } else {
                if instructionText.alpha == 0 {
                    guard let touch = touches.first else {
                        
                        return
                    }
                    let touchLocation = touch.location(in: self)
                    sceneTouched(touchLocation: touchLocation)
                    self.run(self.click)
                }
            } // End of if continue button contains
        } // End of for in
    } // End of override func
    
    public override func update(_ currentTime: TimeInterval) {
        move(sprite: iPhone, velocity: velocity)
        boundsCheckiPhone()
        checkCollisions()
        
        // live count related actions
        if liveCount > 3 {
            livesLabel.text = "iPhone Lives: \(liveCount)"
        } else if liveCount <= 3 && liveCount > 1 {
            livesLabel.text = "iPhone Lives: \(liveCount)"
            livesLabel.fontColor = SKColor.init(red: 255, green: 30, blue: 0, alpha: 1)
        } else if liveCount == 1 {
            livesLabel.text = "iPhone Lives: \(liveCount)"
            livesLabel.fontColor = SKColor.init(red: 255, green: 0, blue: 0, alpha: 1)
        } else if liveCount <= 0 {
            livesLabel.text = "iPhone Lives: 0"
            livesLabel.fontColor = SKColor.init(red: 255, green: 0, blue: 0, alpha: 1)
            // Delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                // Create scene three
                let sceneFour = FailedScene(fileNamed: "SuccessScene")
                sceneFour?.scaleMode = .aspectFill
                sceneFour?.anchorPoint = CGPoint.zero
                
                // Change scene
                self.view?.presentScene(sceneFour!, transition: SKTransition.crossFade(withDuration: 1.0))
            }
        }
        
        // photo taken count related actions
        if photoTakenCount == 1 && numberOfPhotoSpawned == 1{
            photoTakenLabel.text = "Photo Taken: \(photoTakenCount)/5"
            self.spawnPhoto()
        } else if photoTakenCount == 2 && numberOfPhotoSpawned == 2{
            photoTakenLabel.text = "Photo Taken: \(photoTakenCount)/5"
            self.spawnPhoto()
        } else if photoTakenCount == 3 && numberOfPhotoSpawned == 3 {
            photoTakenLabel.text = "Photo Taken: \(photoTakenCount)/5"
            self.spawnPhoto()
        } else if photoTakenCount == 4 && numberOfPhotoSpawned == 4 {
            photoTakenLabel.text = "Photo Taken: \(photoTakenCount)/5"
            self.spawnPhoto()
        } else if photoTakenCount == 5 && numberOfPhotoSpawned == 5 {
            photoTakenLabel.text = "Photo Taken: \(photoTakenCount)/5"
            
            // Delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                // Create scene three
                let sceneFour = SuccessScene(fileNamed: "SuccessScene")
                sceneFour?.scaleMode = .aspectFill
                sceneFour?.anchorPoint = CGPoint.zero
                
                // Change scene
                self.view?.presentScene(sceneFour!, transition: SKTransition.crossFade(withDuration: 1.0))
            }
            
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.continueButton.texture = SKTexture(imageNamed: "continueButton")
        }
    }
    
    
    public override func touchesMoved(_ touches: Set<UITouch>,
                                      with event: UIEvent?) {
        
        // Drag around
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
    
}


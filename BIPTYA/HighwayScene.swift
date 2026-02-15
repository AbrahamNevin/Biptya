import SpriteKit

class HighwayScene: SKScene, SKPhysicsContactDelegate {
    var biptya: SKSpriteNode!
    
    var didChooseCorridor: Bool = false
    
    // Movement Constants
    let moveDistanceX: CGFloat = 300
    let moveDistanceY: CGFloat = 150
    var isMoving = false // For difficulty: prevents spamming jumps
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero
        
        // 1. Setup Background
        let background = SKSpriteNode(imageNamed: "road_topview")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = -1
        background.size = self.size
        addChild(background)
        
        // 2. Setup Biptya
        biptya = SKSpriteNode(imageNamed: "biptya_walk")
        biptya.size = CGSize(width: 150, height: 75)
        // Start lower to increase travel time
        biptya.position = CGPoint(x: frame.midX, y: frame.minY + 60)
        
        biptya.physicsBody = SKPhysicsBody(rectangleOf: biptya.size)
        biptya.physicsBody?.categoryBitMask = 1
        biptya.physicsBody?.contactTestBitMask = 2
        biptya.physicsBody?.isDynamic = true
        addChild(biptya)
        
        setupTraffic()
        createButtons()
    }
    
    // MARK: - TRAFFIC (Increased Difficulty)
    func setupTraffic() {
        // Lanes are spread out more to cover more of the screen
        let lanes = [
            frame.midY + 200,
            frame.midY + 70,
            frame.midY - 70,
            frame.midY - 200
        ]
        
        for i in 0..<4 {
            let car = SKSpriteNode(imageNamed: "car_topview_\(i+1)")
            car.size = CGSize(width: 160, height: 80)
            
            let movingRight = i < 2
            let startX = movingRight ? frame.minX - 150 : frame.maxX + 150
            let endX = movingRight ? frame.maxX + 150 : frame.minX - 150
            
            car.position = CGPoint(x: startX, y: lanes[i])
            
            if !movingRight {
                car.zRotation = .pi
            }
            
            car.physicsBody = SKPhysicsBody(rectangleOf: car.size)
            car.physicsBody?.isDynamic = false
            car.physicsBody?.categoryBitMask = 2
            addChild(car)
            
            // DIFFICULTY TWEAK: Faster speeds (1.5 to 2.5 seconds instead of 4.0)
            let duration = Double.random(in: 1.5...2.5)
            
            let move = SKAction.moveTo(x: endX, duration: duration)
            let reset = SKAction.run { car.position.x = startX }
            let sequence = SKAction.sequence([move, reset])
            car.run(SKAction.repeatForever(sequence))
        }
    }
    
    // MARK: - MOVEMENT & WIN LOGIC
    func moveBiptya(direction: String) {
        if isMoving { return } // Prevent jumping until current jump finishes
        
        var newPosition = biptya.position
        switch direction {
        case "up": newPosition.y += moveDistanceY
        case "down": newPosition.y -= moveDistanceY
        case "left": newPosition.x -= moveDistanceX
        case "right": newPosition.x += moveDistanceX
        default: return
        }
        
        let padding: CGFloat = 40
        if newPosition.x > frame.minX + padding && newPosition.x < frame.maxX - padding &&
           newPosition.y > frame.minY + padding && newPosition.y < frame.maxY + 150 {
            
            isMoving = true
            let moveAction = SKAction.move(to: newPosition, duration: 0.12)
            biptya.run(moveAction) {
                self.isMoving = false
                // If he crosses the road
                if self.biptya.position.y > self.frame.maxY - 100 {
                    self.goToInjuredScene()
                }
            }
        }
    }
    
    // MARK: - COLLISION
    func didBegin(_ contact: SKPhysicsContact) {
        // If a car touches Biptya
        if contact.bodyA.categoryBitMask == 1 || contact.bodyB.categoryBitMask == 1 {
            goToInjuredScene()
        }
    }
    
    func goToInjuredScene() {
            let nextScene = InjuredScene(size: self.size)
            // PASS THE DATA: Move the choice to the next scene
            nextScene.didChooseCorridor = self.didChooseCorridor
            nextScene.scaleMode = .aspectFill
            let transition = SKTransition.crossFade(withDuration: 0.6)
            self.view?.presentScene(nextScene, transition: transition)
        }

    // MARK: - UI BUTTONS
    func createButtons() {
        let btnSize = CGSize(width: 100, height: 100)
        spawnButton(name: "up", pos: CGPoint(x: frame.minX + 80, y: frame.minY + 250), size: btnSize, color: .blue)
        spawnButton(name: "down", pos: CGPoint(x: frame.minX + 80, y: frame.minY + 100), size: btnSize, color: .blue)
        spawnButton(name: "left", pos: CGPoint(x: frame.maxX - 220, y: frame.minY + 150), size: btnSize, color: .red)
        spawnButton(name: "right", pos: CGPoint(x: frame.maxX - 80, y: frame.minY + 150), size: btnSize, color: .red)
    }

    func spawnButton(name: String, pos: CGPoint, size: CGSize, color: UIColor) {
        let btn = SKSpriteNode(color: color, size: size)
        btn.name = name
        btn.position = pos
        btn.alpha = 0.3
        btn.zPosition = 10
        addChild(btn)
        let label = SKLabelNode(text: name.uppercased()); label.fontSize = 20
        label.fontName = "AvenirNext-Bold"; label.verticalAlignmentMode = .center
        btn.addChild(label)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let tappedNodes = nodes(at: touch.location(in: self))
        for node in tappedNodes { if let name = node.name { moveBiptya(direction: name) } }
    }
}

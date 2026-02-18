import SpriteKit

class HighwayScene: SKScene, SKPhysicsContactDelegate {
    var biptya: SKSpriteNode!
    
    var didChooseCorridor: Bool = false
    
    // Movement Constants
    let moveDistanceX: CGFloat = 300
    let moveDistanceY: CGFloat = 150
    var isMoving = false
    
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
        biptya.size = CGSize(width: 400, height: 200)
        biptya.position = CGPoint(x: frame.midX, y: frame.minY + 60)
        
        biptya.physicsBody = SKPhysicsBody(rectangleOf: biptya.size)
        biptya.physicsBody?.categoryBitMask = 1
        biptya.physicsBody?.contactTestBitMask = 2
        biptya.physicsBody?.isDynamic = true
        addChild(biptya)
        
        setupTraffic()
        createButtons()
    }
    
    // MARK: - TRAFFIC (Reduced to 2 Cars)
//    func setupTraffic() {
//        // Defined only 2 lanes now
//        let lanes = [
//            frame.midY + 170, // Upper lane
//            frame.midY - 70  // Lower lane
//        ]
//        
//        // Loop runs exactly 2 times
//        for i in 0..<2 {
//            // Using i+1 for image names (assumes car_topview_1 and car_topview_2 exist)
//            let car = SKSpriteNode(imageNamed: "car_topview\(i+1)")
//            car.size = CGSize(width: 600, height: 300)
//            
//            // Car 0 moves Right, Car 1 moves Left
//            let movingRight = (i == 0)
//            let startX = movingRight ? frame.minX - 150 : frame.maxX + 150
//            let endX = movingRight ? frame.maxX + 150 : frame.minX - 150
//            
//            car.position = CGPoint(x: startX, y: lanes[i])
//            
//            if !movingRight {
//                // Points the car left (180 degrees) without mirroring the image details
//                car.zRotation = .pi * 2
//                // Ensure xScale is reset to 1 in case of recycling
//                car.xScale = 1
//            }
//            
//            car.physicsBody = SKPhysicsBody(rectangleOf: car.size)
//            car.physicsBody?.isDynamic = false
//            car.physicsBody?.categoryBitMask = 2
//            addChild(car)
//            
//            // Random speed for variety
//            let duration = Double.random(in: 1.8...2.8)
//            
//            let move = SKAction.moveTo(x: endX, duration: duration)
//            let reset = SKAction.run { car.position.x = startX }
//            let sequence = SKAction.sequence([move, reset])
//            car.run(SKAction.repeatForever(sequence))
//        }
//    }
    // MARK: - TRAFFIC (Larger, Faster, Full Screen Clearance)
        func setupTraffic() {
            let lanes = [
                frame.midY + 170, // Upper lane
                frame.midY - 70   // Lower lane
            ]
            
            let carWidth: CGFloat = 600
            let carHeight: CGFloat = 300
            
            // Offset ensures the car is fully hidden before resetting
            // We use carWidth (600) + a little extra padding
            let offScreenOffset: CGFloat = carWidth / 2 + 100
            
            for i in 0..<2 {
                let car = SKSpriteNode(imageNamed: "car_topview\(i+1)")
                car.size = CGSize(width: carWidth, height: carHeight)
                
                let movingRight = (i == 0)
                
                // Calculate positions based on the screen edges + the car's width
                let startX = movingRight ? frame.minX - offScreenOffset : frame.maxX + offScreenOffset
                let endX = movingRight ? frame.maxX + offScreenOffset : frame.minX - offScreenOffset
                
                car.position = CGPoint(x: startX, y: lanes[i])
                
                if !movingRight {
                    // .pi is 180 degrees (Facing Left)
                    car.zRotation = .pi * 2
                    car.xScale = 1
                } else {
                    car.zRotation = 0
                    car.xScale = 1
                }
                
                // Re-calculating physics to match the large 600x300 size
                car.physicsBody = SKPhysicsBody(rectangleOf: car.size)
                car.physicsBody?.isDynamic = false
                car.physicsBody?.categoryBitMask = 2
                addChild(car)
                
                // INCREASED SPEED: Lower duration = Faster car
                // Previous was 1.8...2.8. Now it's much faster.
                let duration = Double.random(in: 1.0...1.5)
                
                let move = SKAction.moveTo(x: endX, duration: duration)
                let reset = SKAction.run { car.position.x = startX }
                let sequence = SKAction.sequence([move, reset])
                car.run(SKAction.repeatForever(sequence))
            }
        }
    // MARK: - MOVEMENT & WIN LOGIC
    func moveBiptya(direction: String) {
        if isMoving { return }
        
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
                if self.biptya.position.y > self.frame.maxY - 100 {
                    self.goToInjuredScene()
                }
            }
        }
    }
    
    // MARK: - COLLISION
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == 1 || contact.bodyB.categoryBitMask == 1 {
            goToInjuredScene()
        }
    }
    
    func goToInjuredScene() {
        let nextScene = InjuredScene(size: self.size)
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

//
//  HighwayScene.swift
//  BIPTYA
//
//  Created by Nevin Abraham on 15/02/26.
//
import SpriteKit

class HighwayScene: SKScene {
    // Game Nodes
    var biptya: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        // Set up physics world (Gravity is 0 because it's top-down or side-view)
        physicsWorld.gravity = .zero
        
        // 1. Create Biptya Node
        biptya = SKSpriteNode(imageNamed: "biptya_walk")
        biptya.size = CGSize(width: 80, height: 60)
        biptya.position = CGPoint(x: frame.minX + 100, y: frame.midY)
        
        // Add Physics to Biptya
        biptya.physicsBody = SKPhysicsBody(rectangleOf: biptya.size)
        biptya.physicsBody?.isDynamic = true
        biptya.physicsBody?.categoryBitMask = 1 // Biptya Category
        biptya.physicsBody?.contactTestBitMask = 2 // Car Category
        
        addChild(biptya)
        
        // 2. Start Spawning Cars
        let spawn = SKAction.run { self.spawnCar() }
        let wait = SKAction.wait(forDuration: 1.5)
        run(SKAction.repeatForever(SKAction.sequence([spawn, wait])))
    }
    
    func spawnCar() {
        let car = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 50))
        car.position = CGPoint(x: frame.maxX + 100, y: CGFloat.random(in: frame.minY...frame.maxY))
        
        car.physicsBody = SKPhysicsBody(rectangleOf: car.size)
        car.physicsBody?.isDynamic = false // Car doesn't get pushed back
        car.physicsBody?.categoryBitMask = 2
        
        addChild(car)
        
        // Move car from right to left
        let moveAction = SKAction.moveTo(x: frame.minX - 100, duration: 3.0)
        let removeAction = SKAction.removeFromParent()
        car.run(SKAction.sequence([moveAction, removeAction]))
    }
    
    // Touch Logic to move Biptya
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        biptya.position = location
    }
}

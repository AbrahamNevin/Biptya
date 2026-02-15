import SpriteKit

class InjuredScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        // 1. Setup the Background Image
        let bgImage = SKSpriteNode(imageNamed: "injured_background")
        bgImage.size = self.size
        bgImage.position = CGPoint(x: frame.midX, y: frame.midY)
        bgImage.zPosition = 1
        addChild(bgImage)
        
        // 2. Setup the "Injured" Text
        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.text = "BIPTYA IS INJURED"
        label.fontSize = 50
        label.fontColor = .red
        label.position = CGPoint(x: frame.midX, y: frame.midY)
        label.zPosition = 2
        label.alpha = 0
        addChild(label)
        
        // 3. Setup the Restart Button
        let restartBtn = spawnRestartButton()
        restartBtn.alpha = 0
        addChild(restartBtn)
        
        // --- 4. DRAMATIC SHAKE LOGIC ---
        // We move the image slightly back and forth very quickly
        let shakeAmount: CGFloat = 10
        let shakeLeft = SKAction.moveBy(x: -shakeAmount, y: 0, duration: 0.05)
        let shakeRight = SKAction.moveBy(x: shakeAmount, y: 0, duration: 0.05)
        let shakeSequence = SKAction.sequence([shakeLeft, shakeRight])
        let repeatShake = SKAction.repeat(shakeSequence, count: 20) // Shakes for 2 seconds
        
        // --- 5. ANIMATION SEQUENCES ---
        let wait = SKAction.wait(forDuration: 0.5)
        let fadeOut = SKAction.fadeOut(withDuration: 3.0)
        let fadeIn = SKAction.fadeIn(withDuration: 2.0)
        
        // Run the Shake and Fade together on the background
        bgImage.run(repeatShake)
        bgImage.run(SKAction.sequence([wait, fadeOut]))
        
        // Fade in the labels
        label.run(SKAction.sequence([wait, fadeIn]))
        restartBtn.run(SKAction.sequence([SKAction.wait(forDuration: 4.0), fadeIn]))
    }
    
    func spawnRestartButton() -> SKSpriteNode {
        let button = SKSpriteNode(color: .white, size: CGSize(width: 200, height: 60))
        button.position = CGPoint(x: frame.midX, y: frame.midY - 120)
        button.name = "restart"
        button.zPosition = 3
        
        let btnText = SKLabelNode(fontNamed: "AvenirNext-Bold")
        btnText.text = "TRY AGAIN"
        btnText.fontColor = .black
        btnText.fontSize = 25
        btnText.verticalAlignmentMode = .center
        button.addChild(btnText)
        
        return button
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let tappedNodes = nodes(at: touch.location(in: self))
        
        if tappedNodes.contains(where: { $0.name == "restart" }) {
            let gameScene = HighwayScene(size: self.size)
            gameScene.scaleMode = .aspectFill
            self.view?.presentScene(gameScene, transition: SKTransition.crossFade(withDuration: 1.0))
        }
    }
}

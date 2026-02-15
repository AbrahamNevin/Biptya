import SpriteKit

class InjuredScene: SKScene {
    var didChooseCorridor: Bool = false
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        let bgImage = SKSpriteNode(imageNamed: "injured_background")
        bgImage.size = self.size
        bgImage.position = CGPoint(x: frame.midX, y: frame.midY)
        bgImage.zPosition = 1
        addChild(bgImage)

        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.text = "BIPTYA IS INJURED"; label.fontSize = 50; label.fontColor = .red
        label.position = CGPoint(x: frame.midX, y: frame.midY); label.zPosition = 2; label.alpha = 0
        addChild(label)

        // TWO OPTIONS
        let fenceBtn = spawnButton(name: "buildFence",
                                   text: didChooseCorridor ? "BUILD FENCE" : "FENCE LOCKED",
                                   pos: CGPoint(x: frame.midX, y: frame.midY - 120),
                                   color: didChooseCorridor ? .systemGreen : .darkGray)
        
        let restartBtn = spawnButton(name: "restart",
                                     text: "CONTINUE AS IT IS",
                                     pos: CGPoint(x: frame.midX, y: frame.midY - 220),
                                     color: .white)
        
        // Animations
        let shake = SKAction.repeat(SKAction.sequence([SKAction.moveBy(x: -10, y: 0, duration: 0.05), SKAction.moveBy(x: 10, y: 0, duration: 0.05)]), count: 20)
        bgImage.run(shake)
        bgImage.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.fadeOut(withDuration: 3.0)]))
        label.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.fadeIn(withDuration: 2.0)]))
        
        let btnFade = SKAction.sequence([SKAction.wait(forDuration: 4.0), SKAction.fadeIn(withDuration: 1.0)])
        [fenceBtn, restartBtn].forEach { $0.alpha = 0; addChild($0); $0.run(btnFade) }
    }

    func spawnButton(name: String, text: String, pos: CGPoint, color: UIColor) -> SKSpriteNode {
        let btn = SKSpriteNode(color: color, size: CGSize(width: 300, height: 60))
        btn.name = name; btn.position = pos; btn.zPosition = 3
        let t = SKLabelNode(text: text); t.fontSize = 22; t.fontName = "AvenirNext-Bold"
        t.fontColor = (color == .white) ? .black : .white; t.verticalAlignmentMode = .center
        btn.addChild(t); return btn
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let tapped = nodes(at: touch.location(in: self))
            if tapped.contains(where: { $0.name == "restart" }) {
                let scene = HighwayScene(size: self.size)
                scene.didChooseCorridor = self.didChooseCorridor
                self.view?.presentScene(scene, transition: .crossFade(withDuration: 1))
            } else if tapped.contains(where: { $0.name == "buildFence" }) {
                if didChooseCorridor { print("Go to Fence Build Scene") }
                else {
                    let s = SKAction.repeat(SKAction.sequence([SKAction.moveBy(x: 10, y: 0, duration: 0.05), SKAction.moveBy(x: -10, y: 0, duration: 0.05)]), count: 3)
                    childNode(withName: "buildFence")?.run(s)
                }
            }
        }
    }
}

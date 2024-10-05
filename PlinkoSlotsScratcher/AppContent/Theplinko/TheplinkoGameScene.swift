import SwiftUI
import SpriteKit

class PlinkoInfoGame {
    
    let ods = [
        9: [
            0.6,
            1.1,
            1.3,
            2,
            5,
            5,
            2,
            1.3,
            1.1,
            0.6
        ]
    ]
    
    let colorOds = [
        UIColor.init(red: 126/255, green: 171/255, blue: 233/255, alpha: 1),
        .white,
        UIColor.init(red: 0, green: 120/255, blue: 224/255, alpha: 1),
        UIColor.init(red: 222/255, green: 75/255, blue: 144/255, alpha: 1),
        UIColor.init(red: 255/255, green: 233/255, blue: 0, alpha: 1),
        UIColor.init(red: 255/255, green: 233/255, blue: 0, alpha: 1),
        UIColor.init(red: 222/255, green: 75/255, blue: 144/255, alpha: 1),
        UIColor.init(red: 0, green: 120/255, blue: 224/255, alpha: 1),
        .white,
        UIColor.init(red: 126/255, green: 171/255, blue: 233/255, alpha: 1)
    ]
    
}

class TheplinkoGameScene: SKScene, SKPhysicsContactDelegate {
    
    private var balance: Int = UserDefaults.standard.integer(forKey: "credits") {
        didSet {
            saveBalanceAndShow()
        }
    }
    let plinkoInfoGame = PlinkoInfoGame()
    private var balanceLabel: SKLabelNode!
    
    private var ball: SKSpriteNode!
    
    private var currentBet = 500 {
           didSet {
               currentBetLabel.text = "\(currentBet)"
           }
       }
    private var currentBetLabel: SKLabelNode!
    
    private var betUpButton: SKSpriteNode!
    private var betMinusButton: SKSpriteNode!
    
    private var playButton: SKSpriteNode!
    private var exitBtn: SKSpriteNode!
    private var betMinus: SKSpriteNode!
    private var betPlus: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        size = CGSize(width: 1350, height: 750)
        physicsWorld.contactDelegate = self
        createBackgroundTheplinko()
        
        let plinkoBallStarter = SKSpriteNode(imageNamed: "the_plinko_ball_starter")
        plinkoBallStarter.position = CGPoint(x: size.width / 2 - 25, y: size.height - 50)
        addChild(plinkoBallStarter)
        
        let resultNode = SKSpriteNode(imageNamed: "the_plinko_result")
        resultNode.position = CGPoint(x: 130, y: 100)
        resultNode.size = CGSize(width: 180, height: 130)
        addChild(resultNode)
        
        resultLabel = .init(text: "-")
        resultLabel.fontName = "TitanOne"
        resultLabel.fontSize = 32
        resultLabel.fontColor = .white
        resultLabel.position = CGPoint(x: 130, y: 70)
        addChild(resultLabel)
        
        playButton = SKSpriteNode(imageNamed: "the_plinko_play")
        playButton.position = CGPoint(x: size.width - 130, y: 100)
        playButton.size = CGSize(width: 180, height: 130)
        addChild(playButton)
        
        exitBtn = SKSpriteNode(imageNamed: "exit-button")
        exitBtn.position = CGPoint(x: 100, y: size.height - 100)
        exitBtn.size = CGSize(width: 90, height: 100)
        addChild(exitBtn)
        
        let betBackground = SKSpriteNode(imageNamed: "bet_background")
        betBackground.position = CGPoint(x: size.width - 150, y: size.height / 2)
        betBackground.size = CGSize(width: 200, height: 90)
        addChild(betBackground)
        
        currentBetLabel = .init(text: "\(currentBet)")
        currentBetLabel.position = CGPoint(x: size.width - 150, y: size.height / 2 - 10)
        currentBetLabel.fontName = "TitanOne"
        currentBetLabel.fontSize = 42
        currentBetLabel.fontColor = .white
        addChild(currentBetLabel)
        
        betMinus = SKSpriteNode(imageNamed: "bet_minus_btn")
        betMinus.position = CGPoint(x: size.width - 250, y: size.height / 2)
        betMinus.size = CGSize(width: 80, height: 90)
        betMinus.alpha = 0.5
        addChild(betMinus)
        
        betPlus = SKSpriteNode(imageNamed: "bet_plus_btn")
        betPlus.position = CGPoint(x: size.width - 50, y: size.height / 2)
        betPlus.size = CGSize(width: 80, height: 90)
        addChild(betPlus)
        
        let balanceBackground = SKSpriteNode(imageNamed: "balance-back")
        balanceBackground.position = CGPoint(x: 150, y: size.height / 2)
        balanceBackground.size = CGSize(width: 200, height: 90)
        addChild(balanceBackground)
        
        balanceLabel = .init(text: "\(balance)")
        balanceLabel.fontName = "TitanOne"
        balanceLabel.fontSize = 32
        balanceLabel.fontColor = .white
        balanceLabel.position = CGPoint(x: 170, y: size.height / 2 - 10)
        addChild(balanceLabel)
        
        createPlinkoField()
        createOds()
        setUpNewBall()
    }
    
    private func dropBall() {
        ball.physicsBody?.affectedByGravity = true
        if balance >= currentBet {
            balance -= currentBet
        }
    }
    
    private var result: Int = 0 {
        didSet {
            balance += result
            if result == 0 {
                resultLabel.text = "-"
            } else {
                resultLabel.text = "\(result)"
            }
        }
    }
    
    private var resultLabel: SKLabelNode!
    
    private func saveBalanceAndShow() {
        balanceLabel.text = "\(balance)"
        UserDefaults.standard.set(balance, forKey: "credits")
    }
    
    private func createBackgroundTheplinko() {
        let node = SKSpriteNode(imageNamed: "theplinko_back")
        node.size = size
        node.position = CGPoint(x: size.width / 2, y: size.height / 2)
        node.zPosition = -1
        addChild(node)
    }
    
     private func createPlinkoField() {
         for i in 1...9 {
             let centerPoint = CGPoint(x: size.width / 2, y: size.height / 2)
             let numRows = i + 2
             let pegSize = CGSize(width: 18, height: 18)
             let totalWidth = CGFloat(numRows) * (pegSize.width + 10)
             let startPointX = centerPoint.x - totalWidth
             let startPointY = size.height - 100 - CGFloat(pegSize.height * 3) * CGFloat(i)
             
             for peg in 0..<numRows {
                 let pegNode = SKSpriteNode(imageNamed: "the_plinko_peg")
                 pegNode.size = pegSize
                 pegNode.position = CGPoint(x: startPointX + (CGFloat(peg) * 60), y: startPointY)
                 pegNode.physicsBody = SKPhysicsBody(circleOfRadius: pegNode.size.width / 2)
                 pegNode.physicsBody?.isDynamic = false
                 pegNode.physicsBody?.affectedByGravity = false
                 pegNode.physicsBody?.categoryBitMask = 2
                 pegNode.physicsBody?.collisionBitMask = 1
                 pegNode.physicsBody?.contactTestBitMask = 1
                 pegNode.name = "peg"
                 addChild(pegNode)
             }
         }
     }
     
    private func setUpNewBall() {
        ball = SKSpriteNode(imageNamed: "the_plinko_ball")
        ball.position = CGPoint(x: size.width / 2 - 25, y: size.height - 50)
        ball.size = CGSize(width: 24, height: 24)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.friction = 0.4
        ball.physicsBody?.linearDamping = 0.5
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.restitution = Double.random(in: 0.1...0.7)
        ball.physicsBody?.angularDamping = 0.5  
        ball.physicsBody?.allowsRotation = true
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.categoryBitMask = 1
        ball.physicsBody?.collisionBitMask = 2 | 3
        ball.physicsBody?.contactTestBitMask = 2 | 3
        ball.name = "the_plinko_ball"
        addChild(ball)
    }
    
     private func createOds() {
         let plinkoYEnd = size.height - 200 - CGFloat(18 * 3) * 9
         
         for (index, odItem) in plinkoInfoGame.ods[9]!.enumerated() {
             let color = plinkoInfoGame.colorOds[index]
             let nodeOd = SKSpriteNode(color: .clear, size: CGSize(width: 80, height: 50))
             nodeOd.position = CGPoint(x: 320 + CGFloat(index * 70), y: plinkoYEnd)
             nodeOd.anchorPoint = CGPoint(x: 0, y: 0.5)
             nodeOd.name = "\(odItem)"
             
             let odItemSeparator = SKSpriteNode(imageNamed: "the_plinko_separator")
             odItemSeparator.position = CGPoint(x: 0, y: 0)
             odItemSeparator.size = CGSize(width: 8, height: 60)
             nodeOd.addChild(odItemSeparator)
             
             let text = SKLabelNode(text: "x\(odItem)")
             text.fontName = "TitanOne"
             text.fontSize = 22
             text.fontColor = color
             text.position = CGPoint(x: 35, y: -10)
             nodeOd.addChild(text)
             
             nodeOd.physicsBody = SKPhysicsBody(rectangleOf: nodeOd.size)
             nodeOd.physicsBody?.affectedByGravity = false
             nodeOd.physicsBody?.isDynamic = false
             nodeOd.physicsBody?.categoryBitMask = 3
             nodeOd.physicsBody?.contactTestBitMask = 1
             nodeOd.physicsBody?.collisionBitMask = 1
             
             addChild(nodeOd)
         }
     }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            for node in nodes(at: location) {
                if node == betPlus {
                    if currentBet < 5000 {
                        currentBet += 100
                        if betMinus.alpha == 0.5 {
                            betMinus.run(SKAction.fadeAlpha(to: 1, duration: 0.3))
                        }
                        if currentBet == 5000 {
                            betPlus.run(SKAction.fadeAlpha(to: 0.5, duration: 0.3))
                        }
                    }
                }
                
                if node == betMinus {
                    if currentBet > 500 {
                        currentBet -= 100
                        if betPlus.alpha == 0.5 {
                            betPlus.run(SKAction.fadeAlpha(to: 1, duration: 0.3))
                        }
                        if currentBet == 500 {
                            betMinus.run(SKAction.fadeAlpha(to: 0.5, duration: 0.3))
                        }
                    }
                }
                
                if node == playButton {
                    dropBall()
                }
                
                if node == exitBtn {
                    NotificationCenter.default.post(name: Notification.Name("exit_game"), object: nil)
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA
        let contactB = contact.bodyB
        
        if (contactA.categoryBitMask == 1 && contactB.categoryBitMask == 2) ||
            (contactA.categoryBitMask == 2 && contactB.categoryBitMask == 1) {
            var ballBody: SKPhysicsBody
            var pegBody: SKPhysicsBody
            
            if contactA.categoryBitMask == 1 {
                ballBody = contactA
                pegBody = contactB
            } else {
                ballBody = contactB
                pegBody = contactA
            }
            
            if let node = pegBody.node {
                let pegAnimNode = SKSpriteNode(imageNamed: "pulse_peg")
                pegAnimNode.position = node.position
                pegAnimNode.size = CGSize(width: 14, height: 14)
                addChild(pegAnimNode)
                pegAnimNode.run(SKAction.sequence([
                    SKAction.scale(to: 3, duration: 0.5),
                    SKAction.fadeOut(withDuration: 0.2),
                    SKAction.removeFromParent()
                ]))
            }
        }
        
        if (contactA.categoryBitMask == 1 && contactB.categoryBitMask == 3) ||
            (contactA.categoryBitMask == 3 && contactB.categoryBitMask == 1) {
            var ballBody: SKPhysicsBody
            var odBody: SKPhysicsBody
            
            if contactA.categoryBitMask == 1 {
                ballBody = contactA
                odBody = contactB
            } else {
                ballBody = contactB
                odBody = contactA
            }
            
            if let node = odBody.node,
               let name = node.name {
                let multiply = Double(name) ?? 0.0
                result = Int(Double(currentBet) * multiply)
                
                ball.run(SKAction.sequence([
                    SKAction.fadeOut(withDuration: 0.2),
                    SKAction.removeFromParent()
                ])) {
                    self.setUpNewBall()
                }
            }
        }
    }
     
    
}

#Preview {
    VStack {
        SpriteView(scene: TheplinkoGameScene())
            .ignoresSafeArea()
    }
}

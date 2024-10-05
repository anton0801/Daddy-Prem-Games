import SwiftUI
import SpriteKit

class GoldZeusgGameScene: SKScene {
    
    private var currentBet = 500 {
           didSet {
               currentBetLabel.text = "\(currentBet)"
           }
       }
    private var currentBetLabel: SKLabelNode!
    
    private var balance: Int = UserDefaults.standard.integer(forKey: "credits") {
        didSet {
            saveBalanceAndShow()
        }
    }
    private var balanceLabel: SKLabelNode!
    
    private var playButton: SKSpriteNode!
    private var exitBtn: SKSpriteNode!
    private var betMinus: SKSpriteNode!
    private var betPlus: SKSpriteNode!
    
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
    
    private var slotBaraban1: GoldZeusBaraban!
    private var slotBaraban2: GoldZeusBaraban!
    private var slotBaraban3: GoldZeusBaraban!
    private var slotBaraban4: GoldZeusBaraban!
    private var slotBaraban5: GoldZeusBaraban!
    
    override func didMove(to view: SKView) {
        size = CGSize(width: 1350, height: 750)
        createBackgroundGoldZeus()
        
        let betBackground = SKSpriteNode(imageNamed: "gold_zeus_bet_bg")
        betBackground.position = CGPoint(x: size.width - 150, y: size.height / 2)
        betBackground.size = CGSize(width: 200, height: 90)
        addChild(betBackground)
        
        currentBetLabel = .init(text: "\(currentBet)")
        currentBetLabel.position = CGPoint(x: size.width - 150, y: size.height / 2 - 10)
        currentBetLabel.fontName = "TitanOne"
        currentBetLabel.fontSize = 42
        currentBetLabel.fontColor = .white
        addChild(currentBetLabel)
        
        let resultNode = SKSpriteNode(imageNamed: "gold_zeus_result")
        resultNode.position = CGPoint(x: size.width / 2, y: size.height - 70)
        resultNode.size = CGSize(width: 300, height: 90)
        addChild(resultNode)
        
        resultLabel = .init(text: "-")
        resultLabel.fontName = "TitanOne"
        resultLabel.fontSize = 32
        resultLabel.fontColor = .white
        resultLabel.position = CGPoint(x: size.width / 2, y: size.height - 80)
        addChild(resultLabel)
        
        playButton = SKSpriteNode(imageNamed: "gold_zeus_play")
        playButton.position = CGPoint(x: size.width - 150, y: 100)
        playButton.size = CGSize(width: 200, height: 100)
        addChild(playButton)
        
        exitBtn = SKSpriteNode(imageNamed: "exit-button")
        exitBtn.position = CGPoint(x: 100, y: size.height - 70)
        exitBtn.size = CGSize(width: 90, height: 100)
        addChild(exitBtn)
        
        betMinus = SKSpriteNode(imageNamed: "gold_zeus_minus_bet")
        betMinus.position = CGPoint(x: size.width - 250, y: size.height / 2)
        betMinus.size = CGSize(width: 80, height: 90)
        betMinus.alpha = 0.5
        addChild(betMinus)
        
        betPlus = SKSpriteNode(imageNamed: "gold_zeus_bet_plus")
        betPlus.position = CGPoint(x: size.width - 50, y: size.height / 2)
        betPlus.size = CGSize(width: 80, height: 90)
        addChild(betPlus)
        
        let balanceBackground = SKSpriteNode(imageNamed: "balance-back")
        balanceBackground.position = CGPoint(x: 350, y: size.height - 70)
        balanceBackground.size = CGSize(width: 200, height: 90)
        addChild(balanceBackground)
        
        balanceLabel = .init(text: "\(balance)")
        balanceLabel.fontName = "TitanOne"
        balanceLabel.fontSize = 32
        balanceLabel.fontColor = .white
        balanceLabel.position = CGPoint(x: 380, y: size.height - 80)
        addChild(balanceLabel)
        
        let slotBg = SKSpriteNode(imageNamed: "gold_zeus_slot_bg")
        slotBg.position = CGPoint(x: size.width / 2 - 100, y: size.height / 2 - 50)
        slotBg.size = CGSize(width: 900, height: 590)
        addChild(slotBg)
        
        setUpSlotBarabans()
    }
    
    private func setUpSlotBarabans() {
        let symbs = [
            "gold_zeus1",
            "gold_zeus2",
            "gold_zeus3",
            "gold_zeus4",
            "gold_zeus5",
            "gold_zeus6",
            "gold_zeus7",
            "gold_zeus8",
            "gold_zeus9",
            "gold_zeus10",
            "gold_zeus11",
            "gold_zeus12",
            "gold_zeus13",
            "gold_zeus14",
            "gold_zeus15"
        ]
        slotBaraban1 = GoldZeusBaraban(goldSlotSymbols: symbs, size: CGSize(width: 150, height: 480), spinEndCallback: nil)
        slotBaraban1.position = CGPoint(x: 250, y: size.height / 2 - 50)
        addChild(slotBaraban1)
        slotBaraban2 = GoldZeusBaraban(goldSlotSymbols: symbs, size: CGSize(width: 150, height: 480), spinEndCallback: nil)
        slotBaraban2.position = CGPoint(x: 420, y: size.height / 2 - 50)
        addChild(slotBaraban2)
        slotBaraban3 = GoldZeusBaraban(goldSlotSymbols: symbs, size: CGSize(width: 150, height: 480), spinEndCallback: nil)
        slotBaraban3.position = CGPoint(x: 580, y: size.height / 2 - 50)
        addChild(slotBaraban3)
        slotBaraban4 = GoldZeusBaraban(goldSlotSymbols: symbs, size: CGSize(width: 150, height: 480), spinEndCallback: nil)
        slotBaraban4.position = CGPoint(x: 750, y: size.height / 2 - 50)
        addChild(slotBaraban4)
        slotBaraban5 = GoldZeusBaraban(goldSlotSymbols: symbs, size: CGSize(width: 150, height: 480), spinEndCallback: {
            
        })
        slotBaraban5.position = CGPoint(x: 910, y: size.height / 2 - 50)
        addChild(slotBaraban5)
    }
    
    private func animateNodes(nodes: [SKNode]) {
        for node in nodes {
            let actionScale = SKAction.scale(to: 1.3, duration: 0.3)
            let actionScale2 = SKAction.scale(to: 1, duration: 0.3)
            let seq = SKAction.sequence([actionScale, actionScale2])
            let repeate = SKAction.repeat(seq, count: 3)
            node.run(repeate)
        }
    }
    
    private func checkWinningLines() {
        playButton.alpha = 1
        
        let lineTop1 = atPoint(CGPoint(x: 250, y: size.height / 2 + 120))
        let lineTop2 = atPoint(CGPoint(x: 420, y: size.height / 2 + 120))
        let lineTop3 = atPoint(CGPoint(x: 580, y: size.height / 2 + 120))
        let lineTop4 = atPoint(CGPoint(x: 750, y: size.height / 2 + 120))
        let lineTop5 = atPoint(CGPoint(x: 910, y: size.height / 2 + 120))
        let lineCenter1 = atPoint(CGPoint(x: 250, y: size.height / 2 - 50))
        let lineCenter2 = atPoint(CGPoint(x: 420, y: size.height / 2 - 50))
        let lineCenter3 = atPoint(CGPoint(x: 580, y: size.height / 2 - 50))
        let lineCenter4 = atPoint(CGPoint(x: 750, y: size.height / 2 - 50))
        let lineCenter5 = atPoint(CGPoint(x: 910, y: size.height / 2 - 50))
        let lineBottom1 = atPoint(CGPoint(x: 250, y: size.height / 2 - 120))
        let lineBottom2 = atPoint(CGPoint(x: 420, y: size.height / 2 - 120))
        let lineBottom3 = atPoint(CGPoint(x: 580, y: size.height / 2 - 120))
        let lineBottom4 = atPoint(CGPoint(x: 750, y: size.height / 2 - 120))
        let lineBottom5 = atPoint(CGPoint(x: 910, y: size.height / 2 - 120))
        
        if lineTop1.name == lineTop2.name && lineTop2.name == lineTop3.name && lineTop3.name == lineTop4.name && lineTop4.name == lineTop5.name {
            result += currentBet * 10
            animateNodes(nodes: [lineTop1, lineTop2, lineTop3, lineTop4, lineTop5])
        } else if lineTop1.name == lineTop2.name && lineTop2.name == lineTop3.name && lineTop3.name == lineTop4.name {
            result += currentBet * 4
            animateNodes(nodes: [lineTop1, lineTop2, lineTop3, lineTop4])
        } else if lineTop1.name == lineTop2.name && lineTop2.name == lineTop3.name {
            result += currentBet * 3
            animateNodes(nodes: [lineTop1, lineTop2, lineTop3])
        }
        
        if lineCenter1.name == lineCenter2.name && lineCenter2.name == lineCenter3.name && lineCenter3.name == lineCenter4.name && lineCenter4.name == lineCenter5.name {
            result += currentBet * 10
            animateNodes(nodes: [lineCenter1, lineCenter2, lineCenter3, lineCenter4, lineCenter5])
        } else if lineCenter1.name == lineCenter2.name && lineCenter2.name == lineCenter3.name && lineCenter3.name == lineCenter4.name {
            result += currentBet * 4
            animateNodes(nodes: [lineCenter1, lineCenter2, lineCenter3, lineCenter4])
        } else if lineCenter1.name == lineCenter2.name && lineCenter2.name == lineCenter3.name {
            result += currentBet * 3
            animateNodes(nodes: [lineCenter1, lineCenter2, lineCenter3])
        }
        
        if lineBottom1.name == lineBottom2.name && lineBottom2.name == lineBottom3.name && lineBottom3.name == lineBottom4.name && lineBottom4.name == lineBottom5.name {
            result += currentBet * 10
            animateNodes(nodes: [lineBottom1, lineBottom2, lineBottom3, lineBottom4, lineBottom5])
        } else if lineBottom1.name == lineBottom2.name && lineBottom2.name == lineBottom3.name && lineBottom3.name == lineBottom4.name {
            result += currentBet * 4
            animateNodes(nodes: [lineBottom1, lineBottom2, lineBottom3, lineBottom4])
        } else if lineBottom1.name == lineBottom2.name && lineBottom2.name == lineBottom3.name {
            result += currentBet * 3
            animateNodes(nodes: [lineBottom1, lineBottom2, lineBottom3])
        }
    }
    
    private func saveBalanceAndShow() {
        balanceLabel.text = "\(balance)"
        UserDefaults.standard.set(balance, forKey: "credits")
    }
    
    private func createBackgroundGoldZeus() {
        let node = SKSpriteNode(imageNamed: "gold_zeus_background")
        node.size = size
        node.position = CGPoint(x: size.width / 2, y: size.height / 2)
        node.zPosition = -1
        addChild(node)
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
                    if balance >= currentBet {
                        balance -= currentBet
                        slotBaraban1.startSpinningBaraban()
                        slotBaraban2.startSpinningBaraban()
                        slotBaraban3.startSpinningBaraban()
                        slotBaraban4.startSpinningBaraban()
                        slotBaraban5.startSpinningBaraban()
                    }
                }
                
                if node == exitBtn {
                    NotificationCenter.default.post(name: Notification.Name("exit_game"), object: nil)
                }
            }
        }
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: GoldZeusgGameScene())
            .ignoresSafeArea()
    }
}

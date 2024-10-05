import SpriteKit

class GoldZeusBaraban: SKSpriteNode {
    
    private let barabanCrop: SKCropNode
    var goldZeusSymbols: [String]
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(goldSlotSymbols: [String], size: CGSize, spinEndCallback: (() -> Void)?) {
        self.goldZeusSymbols = goldSlotSymbols
        self.barabanCrop = SKCropNode()
        self.spinEndCallback = spinEndCallback
        self.barabanContent = SKNode()
        super.init(texture: nil, color: .clear, size: size)
        initializeBaraban()
    }
    
    func initializeBaraban() {
        barabanCrop.position = CGPoint(x: 0, y: 0)
        let maskNode = SKSpriteNode(color: .black, size: size)
        maskNode.position = CGPoint(x: 0, y: 0)
        barabanCrop.maskNode = maskNode
        addChild(barabanCrop)
        
        barabanCrop.addChild(barabanContent)
        let shuffledSymbols = goldZeusSymbols.shuffled()
        
        for i in 0..<goldZeusSymbols.count * 8 {
            let symbolName = shuffledSymbols[i % 8]
            let symbol = SKSpriteNode(imageNamed: symbolName)
            symbol.size = CGSize(width: 100, height: 110)
            symbol.zPosition = 1
            symbol.name = symbolName
            symbol.position = CGPoint(x: 0, y: size.height - CGFloat(i) * 160.5)
            barabanContent.addChild(symbol)
        }
        
    
        let barabanYScrollStart = 160.5 * CGFloat(goldZeusSymbols.count * 3)
        barabanContent.run(SKAction.moveBy(x: 0, y: barabanYScrollStart, duration: 0.0))
    }
    var spinEndCallback: (() -> Void)?

    var spinReversedState = false
    
    func startSpinningBaraban() {
        if spinReversedState {
            func spinReversed() {
                spinReversedState = false
                let actionMove = SKAction.moveBy(x: 0, y: -(240.5 * CGFloat(Int.random(in: 4...6))), duration: 0.5)
                barabanContent.run(actionMove) {
                    self.spinEndCallback?()
                }
            }
            spinReversed()
        } else {
            let actionMove = SKAction.moveBy(x: 0, y: 240.5 * CGFloat(Int.random(in: 4...6)), duration: 0.5)
            barabanContent.run(actionMove) {
                self.spinEndCallback?()
            }
            spinReversedState = true
        }
    }
    private let barabanContent: SKNode
    
}

//
//  GameScene.swift
//  BBGame Shared
//
//  Created by kibum on 2023/03/16.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    struct PhysicsCategory {
        
        static let Sword: UInt32 = 0b1     // 1
        static let Enemy: UInt32 = 0b1 << 1 // 2
    }
    
    var scoreLabel = SKLabelNode(fontNamed: "Chalkduster")

    var player = SKSpriteNode(imageNamed: "character.png")
    var background1 = SKSpriteNode(imageNamed: "background.png")
    var background2 = SKSpriteNode(imageNamed: "background.png")
    var jumpButton = SKSpriteNode(imageNamed: "jump.png")
    var attackButton = SKSpriteNode(imageNamed: "attack.png")
    private var Panda = SKSpriteNode(imageNamed: "panda1")
    private var PandaRunningFrame : [SKTexture] = [
        SKTexture(imageNamed: "panda1"),
        SKTexture(imageNamed: "panda2"),
        SKTexture(imageNamed: "panda3"),
        SKTexture(imageNamed: "panda4"),
        SKTexture(imageNamed: "panda5")
    ]
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .fill
        return scene
    }
    
    func addPhysicsBoundariesToScene() {
        let physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -(view?.frame.size.width)!, y: -(view?.frame.size.height)!), to: CGPoint(x: (view?.frame.size.width)!, y: -(view?.frame.size.height)!))
            physicsBody.isDynamic = false
            self.physicsBody = physicsBody
    }
    
    func setUpBackground(){
        let images = [
                    UIImage(named: "background.png")!,
                    UIImage(named: "background.png")!
                ]
        let scroller = InfiniteScrollingBackground(images: images,
                                               scene: self,
                                               scrollDirection: .left,
                                               transitionSpeed: 3)
        
        scroller?.scroll()
        scroller?.zPosition = 0
    }
    
    func settingScore() {
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 550, y: 400)
        scoreLabel.zPosition = 3
        scoreLabel.fontColor = .black
        scoreLabel.fontSize = 100
        addChild(scoreLabel)
    }
    
    func setUpButtons(){
        jumpButton.position = CGPoint(x: 500, y: -300)
        jumpButton.name = "jump"
        
        jumpButton.zPosition = 2
        
        addChild(jumpButton)
        
        attackButton.position = CGPoint(x: 300, y: -300)
        attackButton.name = "attack"
        
        attackButton.zPosition = 2
        
        addChild(attackButton)
    }
    
    func setUpPlayer(){
        player.position = CGPoint(x: -500, y: -200)
        player.name = "player"
        
        player.zPosition = 1
        
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width, height: player.size.height))
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.restitution = 0.0
        player.physicsBody?.allowsRotation = false
        addChild(player)
    }
    
    private func shootingSoard(){
        let sword = SKSpriteNode(imageNamed: "soard.png")
        sword.position = CGPoint(x: player.position.x + 300, y: player.position.y)
        sword.name = "sword"
        
        sword.zPosition = 1
        sword.zRotation = 0
        
        sword.size = CGSize(width: 300, height: 300)
        
        sword.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sword.size.width, height: sword.size.height))
        sword.physicsBody!.contactTestBitMask = sword.physicsBody!.collisionBitMask
        sword.physicsBody?.affectedByGravity = false
        sword.physicsBody?.allowsRotation = false
        sword.physicsBody?.isDynamic = false
        
        sword.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.moveBy(x: 100, y: 0, duration: 0.5),
            SKAction.moveBy(x: 0, y: 0, duration: 0.0)
        ])))
        
        addChild(sword)
        
        
    }
    
    func setUpObstacles(){
        let box = SKSpriteNode(imageNamed: "barrier.png")
        box.name = "barrier"
        box.zPosition = 1
        box.position = CGPoint(x: (view?.frame.width)! - 50, y: -200)
        
        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
        box.physicsBody?.isDynamic = true
        
//        box.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        
        box.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.moveBy(x: -100, y: 0, duration: 1.0),
            SKAction.moveBy(x: 0, y: 0, duration: 0.0)
        ])))
        
        addChild(box)
    }
    
    func setUpPandas() {
        Panda.position = CGPoint(x: 500, y: -200)
        Panda.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.animate(with: PandaRunningFrame,
                             timePerFrame: 0.1,
                             resize: false,
                             restore: true),
            SKAction.moveBy(x: -100, y: 0, duration: 1.0)
        ])))
        Panda.zPosition = 2
        Panda.physicsBody = SKPhysicsBody(rectangleOf: Panda.size)
        Panda.physicsBody?.affectedByGravity = true
        Panda.physicsBody?.isDynamic = true
        
        Panda.physicsBody?.categoryBitMask = PhysicsCategory.Enemy

        addChild(Panda)
    }
    
    func setUpScene() {
        addPhysicsBoundariesToScene()
        setUpButtons()
        setUpBackground()
        setUpPlayer()
        settingScore()
        setUpPandas()
    }
    
    func movingCharacterToTapPosition(with dextX: CGFloat, dextY: CGFloat){
        player.run(SKAction.move(to: CGPoint(x: dextX, y: dextY), duration: 0.5))
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        self.setUpScene()
        
//        run(SKAction.repeatForever(SKAction.sequence([
//            SKAction.run(setUpObstacles),
//            SKAction.wait(forDuration: 3.0)
//        ])))
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        object.removeFromParent()
        ball.removeFromParent()
    }

    func makeSpinny(at pos: CGPoint, color: SKColor) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if nodeA.name == "sword" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "sword" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
}

#if os(iOS) || os(tvOS)

// Touch-based event handling
extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            
            let nodesArray = self.nodes(at: location)
            if nodesArray.first?.name == "jump" {
                movingCharacterToTapPosition(with: -500, dextY: 100)
            }
            else if nodesArray.first?.name == "attack" {
                shootingSoard()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
   
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {

    override func mouseDown(with event: NSEvent) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        self.makeSpinny(at: event.location(in: self), color: SKColor.purple)
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.makeSpinny(at: event.location(in: self), color: SKColor.yellow)
    }
    
    override func mouseUp(with event: NSEvent) {
        self.makeSpinny(at: event.location(in: self), color: SKColor.white)
    }

}
#endif


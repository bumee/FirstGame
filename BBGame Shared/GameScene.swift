//
//  GameScene.swift
//  BBGame Shared
//
//  Created by kibum on 2023/03/16.
//

import SpriteKit

class GameScene: SKScene {
    
    
    var player = SKSpriteNode(imageNamed: "character.png")
    var background1 = SKSpriteNode(imageNamed: "background.png")
    var background2 = SKSpriteNode(imageNamed: "background.png")
    
    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFit
        return scene
    }
    
    func addPhysicsBoundariesToScene() {
            let physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
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
        scroller?.zPosition = -1
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
    
    func setUpObstacles(){
        let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
        box.zRotation = 0
        box.position = CGPoint(x: 200, y: -200)
        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
        box.physicsBody?.isDynamic = false
        
        box.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.moveBy(x: -100, y: 0, duration: 1.0),
            SKAction.moveBy(x: 0, y: 0, duration: 0.0)
        ])))
        addChild(box)
    }
    
    func setUpScene() {
        addPhysicsBoundariesToScene()
        setUpBackground()
        setUpPlayer()
//        setUpObstacles()
    }
    
    func movingCharacterToTapPosition(with dextX: CGFloat, dextY: CGFloat){
        player.run(SKAction.move(to: CGPoint(x: dextX, y: dextY), duration: 0.5))
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
    }

    func makeSpinny(at pos: CGPoint, color: SKColor) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}

#if os(iOS) || os(tvOS)

// Touch-based event handling
extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        movingCharacterToTapPosition(with: -500, dextY: 100)
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


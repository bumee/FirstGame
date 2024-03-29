//
//  InfiniteScrolling.swift
//  BBGame iOS
//
//  Created by kibum on 2023/03/19.
//

import Foundation

import SpriteKit

class InfiniteScrollingBackground {

    enum ScrollDirection {
        case top, bottom, left, right
    }

    public var speed : CGFloat {
        get { return getSpeed() }
        set { setSpeed(newValue) }
    }
    
    public var zPosition : CGFloat {
        get { return getZPosition() }
        set { setZPosition(newValue) }
    }
    
    public var alpha : CGFloat {
        get { return getAlpha() }
        set { setAlpha(newValue) }
    }
    
    public var isPaused : Bool {
        get { return getIsPaused() }
        set { setIsPaused(newValue) }
    }

    public unowned let scene : SKScene
    public let sprites : [SKSpriteNode]
    public let transitionSpeed : TimeInterval
    public let scrollDirection : ScrollDirection

    init?(images : [UIImage], scene : SKScene, scrollDirection : ScrollDirection, transitionSpeed : Double) {

        guard images.count > 1 else {
            InfiniteScrollingBackground.printInitErrorMessage("You must provide at least 2 images!")
            return nil
        }
        guard (transitionSpeed > 0) && (transitionSpeed <= 100) else {
            InfiniteScrollingBackground.printInitErrorMessage("The transitionSpeed must be between 0 and 100!")
            return nil
        }

        let spriteSize = InfiniteScrollingBackground.spriteNodeSize(scrollDirection, images[0].size, scene)
        self.sprites = InfiniteScrollingBackground.createSpriteNodes(from: images, spriteSize)
        self.scene = scene
        self.scrollDirection = scrollDirection
        self.transitionSpeed = transitionSpeed

        setSpritesAnchorPoints()
    }

    public func scroll() {
        switch scrollDirection {
        case .bottom:
            scrollDown()
        case .top:
            scrollUp()
        case .right:
            scrollToTheRight()
        case .left:
            scrollToTheLeft()
        }
    }

    private func scrollToTheRight() {
        let numberOfSprites = sprites.count
        let transitionDuration = self.transitionDuration(transitionSpeed: transitionSpeed)
        for index in 0...numberOfSprites - 1 {
            sprites[index].position = CGPoint(x: sprites[index].size.width/2 - (CGFloat(index) * sprites[index].size.width), y: sceneSize().height/2)
            let initialMovementAction = SKAction.moveTo(x: 1.5 * sprites[index].size.width, duration: transitionDuration * Double(index + 1))
            let permanentMovementAction = SKAction.moveTo(x: 1.5 * sprites[index].size.width, duration: transitionDuration * Double(numberOfSprites))
            let putsImageOnTheRight = SKAction.moveTo(x: sprites[index].size.width/2 - (sprites[index].size.width * CGFloat(numberOfSprites - 1)), duration: 0.0)
            sprites[index].run(SKAction.sequence([initialMovementAction, putsImageOnTheRight, SKAction.repeatForever(SKAction.sequence([permanentMovementAction, putsImageOnTheRight]))]))
            scene.addChild(sprites[index])
        }
    }

    private func scrollToTheLeft() {
        let numberOfSprites = sprites.count
        let transitionDuration = self.transitionDuration(transitionSpeed: transitionSpeed)
        for index in 0...numberOfSprites - 1 {
            sprites[index].position = CGPoint(x: sprites[index].size.width/2 + (CGFloat(index) * sprites[index].size.width), y: sceneSize().height/2)
            let initialMovementAction = SKAction.moveTo(x: -1 * sprites[index].size.width/2, duration: transitionDuration * Double(index + 1))
            let permanentMovementAction = SKAction.moveTo(x: -1 * sprites[index].size.width/2, duration: transitionDuration * Double(numberOfSprites))
            let putsImageOnTheLeft = SKAction.moveTo(x: sprites[index].size.width/2 + (sprites[index].size.width * CGFloat(numberOfSprites - 1)), duration: 0.0)
            sprites[index].run(SKAction.sequence([initialMovementAction, putsImageOnTheLeft, SKAction.repeatForever(SKAction.sequence([permanentMovementAction, putsImageOnTheLeft]))]))
            scene.addChild(sprites[index])
        }
    }

    private func scrollUp() {
        let numberOfSprites = sprites.count
        let transitionDuration = self.transitionDuration(transitionSpeed: transitionSpeed)
        for index in 0...numberOfSprites - 1 {
            sprites[index].position = CGPoint(x: sceneSize().width/2, y: sprites[index].size.height/2 - (CGFloat(index) * sprites[index].size.height))
            let initialMovementAction = SKAction.moveTo(y: 1.5 * sprites[index].size.height, duration: transitionDuration * Double(index + 1))
            let permanentMovementAction = SKAction.moveTo(y: 1.5 * sprites[index].size.height, duration: transitionDuration * Double(numberOfSprites))
            let putsImageOnBottomAction = SKAction.moveTo(y: sprites[index].size.height/2 - (sprites[index].size.height * CGFloat(numberOfSprites - 1)), duration: 0.0)
            sprites[index].run(SKAction.sequence([initialMovementAction, putsImageOnBottomAction, SKAction.repeatForever(SKAction.sequence([permanentMovementAction, putsImageOnBottomAction]))]))
            scene.addChild(sprites[index])
        }
    }

    private func scrollDown() {
        let numberOfSprites = sprites.count
        let transitionDuration = self.transitionDuration(transitionSpeed: transitionSpeed)
        for index in 0...numberOfSprites - 1 {
            sprites[index].position = CGPoint(x: sceneSize().width/2, y: sprites[index].size.height/2 + (CGFloat(index) * sprites[index].size.height))
            let initialMovementAction = SKAction.moveTo(y: -1 * sprites[index].size.height/2, duration: transitionDuration * Double(index + 1))
            let permanentMovementAction = SKAction.moveTo(y: -1 * sprites[index].size.height/2, duration: transitionDuration * Double(numberOfSprites))
            let putsImageOnTopAction = SKAction.moveTo(y: sprites[index].size.height/2 + (sprites[index].size.height * CGFloat(numberOfSprites - 1)), duration: 0.0)
            sprites[index].run(SKAction.sequence([initialMovementAction, putsImageOnTopAction, SKAction.repeatForever(SKAction.sequence([permanentMovementAction, putsImageOnTopAction]))]))
            scene.addChild(sprites[index])
        }
    }

    private func transitionDuration(transitionSpeed : Double) -> TimeInterval {
        return 50.0/transitionSpeed
    }

    private func sceneSize() -> CGSize {
        return scene.size
    }

    private func setSpritesAnchorPoints() {
        for sprite in sprites {
            sprite.anchorPoint.x = scene.anchorPoint.x + 0.5
            sprite.anchorPoint.y = scene.anchorPoint.y + 0.5
        }
    }

    private static func spriteNodeSize(_ direction : ScrollDirection, _ imageSize : CGSize, _ scene : SKScene) -> CGSize {
        var size = CGSize()
        switch direction {
        case .top, .bottom:
            let width = scene.frame.width
            let aspectRatio = imageSize.width/imageSize.height
            size = CGSize(width: width, height: width/aspectRatio)
        case .left, .right:
            let height = scene.frame.height
            let aspectRatio = imageSize.width/imageSize.height
            size = CGSize(width: height * aspectRatio, height: height)
        }
        return size
    }

    private static func createSpriteNodes(from images : [UIImage], _ size : CGSize) -> [SKSpriteNode] {
        var tempSprites = [SKSpriteNode]()
        for image in images {
            let texture = SKTexture(image: image)
            let sprite = SKSpriteNode(texture: texture, color: .clear, size: size)
            tempSprites.append(sprite)
        }
        return tempSprites
    }

    private func getSpeed() -> CGFloat {
        return sprites[0].speed
    }
    
    private func setSpeed(_ value : CGFloat) {
        for sprite in sprites {
            sprite.speed = value
        }
    }
    
    private func getIsPaused() -> Bool {
        return sprites[0].isPaused
    }
    
    private func setIsPaused(_ value : Bool) {
        for sprite in sprites {
            sprite.isPaused = value
        }
    }
    
    private func getAlpha() -> CGFloat {
        return sprites[0].alpha
    }
    
    private func setAlpha(_ value : CGFloat) {
        for sprite in sprites {
            sprite.alpha = value
        }
    }
    
    private func getZPosition() -> CGFloat {
        return sprites[0].zPosition
    }
    
    private func setZPosition(_ value : CGFloat) {
        for sprite in sprites {
            sprite.zPosition = value
        }
    }

    static private func printInitErrorMessage(_ message : String) {
        print("InfiniteScrollingBackground Initialization Error - \(message)")
    }
}

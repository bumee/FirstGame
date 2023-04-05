//
//  LoadingScene.swift
//  BBGame
//
//  Created by kibum on 2023/03/19.
//

import SpriteKit

class LoadingScene: SKScene {
    
    var background = SKSpriteNode()
    
    private func LoadingsetUpBackground(){
        let images = [
                    UIImage(named: "background.png")!,
                    UIImage(named: "background.png")!,
                    UIImage(named: "background.png")!
                ]
        let scroller = InfiniteScrollingBackground(images: images,
                                               scene: self,
                                               scrollDirection: .left,
                                               transitionSpeed: 3)
        
        scroller?.scroll()
        scroller?.zPosition = 1
    }
    
    override func didMove(to view: SKView) {
        self.LoadingsetUpBackground()
        
        let playBtn = SKSpriteNode(imageNamed: "play")
        playBtn.size = CGSize(width: 200, height: 200)
        
        playBtn.name = "playBtn"
        playBtn.position = CGPoint(x: 425, y: 200)
        playBtn.zPosition = 2
        self.addChild(playBtn)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            if nodesArray.first?.name == "playBtn" {
                let scene = GameScene.newGameScene()
                self.view?.presentScene(scene)
            }
        }
    }
}

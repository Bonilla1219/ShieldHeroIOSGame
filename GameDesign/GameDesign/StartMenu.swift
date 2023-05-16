//
//  StartMenu.swift
//  GameDesign
//
//  Created by Javier Bonilla on 4/29/23.
//

import Foundation
import SpriteKit
import AVFoundation

class StartMenu: SKScene{
    //setting score variable
    var startMusic: AVAudioPlayer?
    
    override func didMove(to view: SKView) {
        
       addTitle()
        
        addBackgroundTexture()
        //gameoverMusicHandler()
        addStartButton()
        
        
    }
    
//    func gameoverMusicHandler(){
//        if let musicURL = Bundle.main.url(forResource: "fail", withExtension: "mp3") {
//            do {
//                gameoverMusic = try AVAudioPlayer(contentsOf: musicURL)
//                gameoverMusic?.numberOfLoops = 0
//                gameoverMusic?.volume = 0.2
//                gameoverMusic?.play()
//            } catch {
//                print("Error playing music: \(error.localizedDescription)")
//            }
//        }
//    }
    
    func addBackgroundTexture(){
        
        let backgroundTexture = SKTexture(imageNamed: "castle")
        let backgroundNode = SKSpriteNode(texture: backgroundTexture, size: CGSize(width: 500, height: self.size.height))
        backgroundNode.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(backgroundNode)
        
    }
    
    func addTitle(){
        
        let titleNode = SKLabelNode(text: "Shield Hero")
        titleNode.position = CGPoint(x: frame.midX, y: (frame.midY + 200))
        titleNode.fontName = "PressStart2P-Regular"
        titleNode.fontColor = .black
        titleNode.zPosition = 2
        
        let shieldTexture = SKTexture(imageNamed: "shield")
        let shieldSpriteNode = SKSpriteNode(texture: shieldTexture, size: CGSize(width: 100, height: 100))
        shieldSpriteNode.position = CGPoint(x: frame.midX, y: (frame.midY + 300))
        shieldSpriteNode.zPosition = 1
        self.addChild(shieldSpriteNode)
        
        
//        let backgroundNode = SKShapeNode(rect: CGRect(x: titleNode.frame.origin.x - 15, y: titleNode.frame.origin.y - 10, width: titleNode.frame.width + 30, height: titleNode.frame.height + 20), cornerRadius: 10)
//        backgroundNode.fillColor = .black
//        backgroundNode.strokeColor = .black
//        backgroundNode.zPosition = 1
//        self.addChild(backgroundNode)
        self.addChild(titleNode)
        
    }
    
    func addStartButton(){
        
        let startButton = SKLabelNode(text: "Start")
        startButton.position = CGPoint(x: frame.midX, y: (frame.midY - 200))
        startButton.name = "startButton"
        startButton.fontName = "PressStart2P-Regular"
        startButton.zPosition = 2
        
        
        let backgroundNode = SKShapeNode(rect: CGRect(x: startButton.frame.origin.x - 15, y: startButton.frame.origin.y - 10, width: startButton.frame.width + 30, height: startButton.frame.height + 20), cornerRadius: 10)
        backgroundNode.fillColor = .black
        backgroundNode.strokeColor = .black
        backgroundNode.zPosition = 1
        self.addChild(backgroundNode)
        self.addChild(startButton)
        
        
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let location = touch.location(in: self)
                let node = self.atPoint(location)
                if node.name == "startButton" {
                    // go back to the game scene
                    let gameScene = Game(size: CGSize(width: size.width, height: size.height))
                    self.view?.presentScene(gameScene, transition: .fade(withDuration: 0.3))
                }
            }
        }
}

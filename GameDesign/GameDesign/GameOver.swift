//
//  GameOver.swift
//  GameDesign
//
//  Created by Javier Bonilla on 4/28/23.
//

import Foundation
import SwiftUI
import SpriteKit
import AVFoundation


class GameOver: SKScene{
    //setting score variable
    var score:Int?
    var gameoverMusic: AVAudioPlayer?
    
    //nodes
    var scoreLabelNode:SKLabelNode!
    
    override func didMove(to view: SKView) {
        
       let gameOverLabelNode = SKLabelNode(text: "Gameover")
        gameOverLabelNode.fontName = "PressStart2P-Regular"
        gameOverLabelNode.fontColor = .white
        gameOverLabelNode.fontSize = 45
        gameOverLabelNode.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(gameOverLabelNode)
         
        setScoreValue()
        gameoverMusicHandler()
        setRestartButton()
        
        
    }
    
    func setRestartButton(){
        let restartButton = SKLabelNode(text: "Restart")
        restartButton.fontName = "PressStart2P-Regular"
        restartButton.position = CGPoint(x: frame.midX, y: (frame.midY - 200))
        restartButton.name = "restartButton"
        restartButton.zPosition = 2
        
        
        let backgroundNode = SKShapeNode(rect: CGRect(x: restartButton.frame.origin.x - 15, y: restartButton.frame.origin.y - 10, width: restartButton.frame.width + 30, height: restartButton.frame.height + 20), cornerRadius: 10)
        backgroundNode.fillColor = .black
        backgroundNode.strokeColor = .black
        backgroundNode.zPosition = 1
        self.addChild(backgroundNode)
        self.addChild(restartButton)
    }
    
    func gameoverMusicHandler(){
        if let musicURL = Bundle.main.url(forResource: "fail", withExtension: "mp3") {
            do {
                gameoverMusic = try AVAudioPlayer(contentsOf: musicURL)
                gameoverMusic?.numberOfLoops = 0
                gameoverMusic?.volume = 0.2
                gameoverMusic?.play()
            } catch {
                print("Error playing music: \(error.localizedDescription)")
            }
        }
    }
    
    func setScoreValue(){
        scoreLabelNode = SKLabelNode(text: "Score: " + String(score ?? 0))
        scoreLabelNode.fontName = "PressStart2P-Regular"
        scoreLabelNode.fontColor = .white
        scoreLabelNode.fontSize = 35
        scoreLabelNode.position = CGPoint(x: frame.midX, y:(frame.midY - 100))
        self.addChild(scoreLabelNode)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let location = touch.location(in: self)
                let node = self.atPoint(location)
                if node.name == "restartButton" {
                    // go back to the game scene
                    let gameScene = Game(size: CGSize(width: size.width, height: size.height))
                    self.view?.presentScene(gameScene, transition: .fade(withDuration: 0.5))
                }
            }
        }
}




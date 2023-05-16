//
//  Game.swift
//  GameDesign
//
//  Created by Javier Bonilla on 4/18/23.
//

import Foundation
import SwiftUI
import SpriteKit
import AVFoundation

//values used to detect collision
struct colliderType{
    
    static let shield:UInt32 = 1
    static let projectile:UInt32 = 2
    static let princess:UInt32 = 3
    
}

class Game: SKScene, SKPhysicsContactDelegate{
    var myTimer:Timer?
    var playerScore:Int = 0
    var highScore:Int = 0
    var spawnTimer:Double = 3.0
    var moveValue:Double = 2.0
    var kft:Double = 0
    var kftDelta:Double = 0.01
    var backgroundMusic: AVAudioPlayer?

    
    
    //node initialization
    var shieldNode:SKSpriteNode!
    var arrowNode:SKSpriteNode!
    var fireballNode:SKSpriteNode!
    var princessNode:SKSpriteNode!
    var scoreLabelNode: SKLabelNode!
    var highScoreLabelNode: SKLabelNode!
    var heartsNodes: [SKSpriteNode] = []
    //var backgroundMusic: SKAudioNode!

    //projectile spawn direction
    var spawnUp: CGPoint!
    var spawnDown: CGPoint!
    var spawnLeft: CGPoint!
    var spawnRight: CGPoint!
    
    //setting position that the node will move to
    var toMiddle: CGPoint!
    
    //shield defend position
    var defendUP: CGPoint!
    var defendRight: CGPoint!
    var defendLeft: CGPoint!
    
    //when the screen loads this is the stuff we are loading in right away
    override func didMove(to view: SKView) {
        //setting physics
        self.physicsWorld.contactDelegate = self
        //adding background to the scene
        addBackgroundTexture()
        //adding background music
        if let musicURL = Bundle.main.url(forResource: "Mountain_Background", withExtension: "mp3") {
            do {
                backgroundMusic = try AVAudioPlayer(contentsOf: musicURL)
                backgroundMusic?.numberOfLoops = -1 // infinite loop
                backgroundMusic?.volume = 0.6
                backgroundMusic?.play()
            } catch {
                print("Error playing music: \(error.localizedDescription)")
            }
        }

        //setting where the prjectiles are moving to
        toMiddle = CGPoint(x: frame.midX, y: frame.midY)
        
        //setting the spawnDirections for projectiles  that will fly in
        spawnUp = CGPoint(x: frame.midX, y: frame.maxY)
        spawnDown = CGPoint(x: frame.midX, y: frame.minY)
        spawnLeft = CGPoint(x: frame.minX, y: frame.midY)
        spawnRight = CGPoint(x: frame.maxX, y: frame.midY)
        
        createHealthBar()
        createScoreBar()
        retriveHighScore()
        addShieldAsset()
        addPrincessAsset()
        addSwipe()
    }
    
    override func update(_ currentTime: TimeInterval) {
        //kft will keep adding spawn in the projectiles for us
        kft = kft + kftDelta
        
        if(kft >= spawnTimer){
            if(spawnTimer > 0.5){
                spawnTimer = spawnTimer - 0.10
            }
            else{
                spawnTimer = 0.5
                
                if(moveValue > 1.5){
                    moveValue = moveValue - 0.10
                }
                else{
                    moveValue = 1.8
                }
            }
            
            kft = 0
            
            //spawn the arrows
            let moveAction = SKAction.move(to: self.toMiddle, duration: moveValue)
            let newProjectile:SKNode = self.projectileRender()
            newProjectile.name = "arrow"
            self.addChild(newProjectile)
            newProjectile.run(moveAction)
            
            //spawn the fireballs if second is enabled
            if(playerScore >= 1500){
                let moveAction = SKAction.move(to: self.toMiddle, duration: 1.4)
                let newProjectile:SKNode = self.fireProjectileRender()
                newProjectile.name = "fireball"
                self.addChild(newProjectile)
                newProjectile.run(moveAction)
            }
        }
        
        //print(kft)
        
       
    }
    
    //summary:
    //retriving the highscore from the text file to set at top
    func retriveHighScore(){
        let file = "HighScore.txt" //this is the file. we will write to and read from it

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(file)

            //reading
            do {
                let text2 = try String(contentsOf: fileURL, encoding: .utf8)
                highScore = Int(text2) ?? 0
                highScoreLabelNode.text = "High Score: " + String(highScore)
                //print(text2)
            }
            catch {
                //print("nope")
            }
        }
    }
    
    //summary:
    //setting the highscore at the top
    func setHighScore(){
        let file = "HighScore.txt" //this is the file. we will write to and read from it
        
        let text = String(highScore);
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(file)

            //writing
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
                //print("highscore set")
            }
            catch {
                print("No file/no high score set!")
            }

        }
        
    }
    
    
        
    //Summary:
    //adding swipe functionality to detect the direction that is being swiped
    func addSwipe() {
        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left, .up, .down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
            gesture.direction = direction
            self.view?.addGestureRecognizer(gesture)
        }
    }

    //Summary:
    //adding background texture to the game
    func addBackgroundTexture(){
        
        let backgroundTexture = SKTexture(imageNamed: "backgroundImage2")
        let backgroundNode = SKSpriteNode(texture: backgroundTexture, size: CGSize(width: 400, height: self.size.height))
        backgroundNode.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(backgroundNode)
        
    }
    
    //summary
    //adds the shield asset that is used to block incoming projectiles
    func addShieldAsset(){
        let shieldAsset = SKTexture(imageNamed: "Hero-shield1")
        shieldNode = SKSpriteNode(texture: shieldAsset, size: CGSize(width: 50, height: 50))
        shieldNode.position = CGPoint(x: frame.midX, y: frame.midY + 50)
        shieldNode.zRotation = -1.5708
        shieldNode.xScale = 1.0
        shieldNode.physicsBody = SKPhysicsBody(rectangleOf: shieldNode.size)
        shieldNode.physicsBody?.affectedByGravity = false
        shieldNode.name = "shield"
        shieldNode.physicsBody?.categoryBitMask = colliderType.shield
        shieldNode.physicsBody?.collisionBitMask = colliderType.projectile
        shieldNode.physicsBody?.contactTestBitMask = colliderType.projectile

        self.addChild(shieldNode)
    }
    
    //summary
    //adds the princess to the middle that needs to be protected
    func addPrincessAsset(){
        let shieldAsset = SKTexture(imageNamed: "Princess")
        princessNode = SKSpriteNode(texture: shieldAsset, size: CGSize(width: 50, height: 50))
        princessNode.position = CGPoint(x: frame.midX, y: frame.midY)
        princessNode.physicsBody = SKPhysicsBody(rectangleOf: shieldNode.size)
        princessNode.physicsBody?.affectedByGravity = false
        princessNode.name = "princess"
        princessNode.physicsBody?.categoryBitMask = colliderType.princess
        princessNode.physicsBody?.collisionBitMask = colliderType.projectile
        princessNode.physicsBody?.contactTestBitMask = colliderType.projectile
        
        self.addChild(princessNode)
    }
    
    //summary
    //creates the score at the top of screen
    func createScoreBar(){
        //setting a black bar on top for score
        let scoreBar = SKSpriteNode(color: .black, size: CGSize(width: size.width, height: 100))
        scoreBar.position = CGPoint(x: size.width / 2, y: size.height - 50)
        scoreBar.zPosition = 100
        self.addChild(scoreBar)
        
        scoreLabelNode = SKLabelNode(text: "Score: " + String(playerScore))
        scoreLabelNode.fontName = "PressStart2P-Regular"
        scoreLabelNode.fontColor = .white
        scoreLabelNode.fontSize = 20
        scoreLabelNode.position = CGPoint(x: 0, y: -40) // position label relative to parent node
        scoreBar.addChild(scoreLabelNode)
        
        highScoreLabelNode = SKLabelNode(text: "High Score: " + String(highScore))
        highScoreLabelNode.fontName = "PressStart2P-Regular"
        highScoreLabelNode.fontColor = .white
        highScoreLabelNode.fontSize = 20
        highScoreLabelNode.position = CGPoint(x: 0, y: -15) // position label relative to parent node
        scoreBar.addChild(highScoreLabelNode)
    }
    
    //summary
    //shows hearts at bottom of screen to indicate health
    func createHealthBar(){
        //setting a black bar on bottom for health
        let healthBar = SKSpriteNode(color: .black, size: CGSize(width: size.width, height: 100))
        healthBar.position = CGPoint(x: size.width / 2, y: 50)
        healthBar.zPosition = 100
        self.addChild(healthBar)
        
        let shieldAsset = SKTexture(imageNamed: "heart")
        var xPosition:CGFloat = -50
        var i = 0
        while(i < 3){
            let heartSpriteNode = SKSpriteNode(texture: shieldAsset, size: CGSize(width: 100, height: 100))
            heartSpriteNode.position = CGPoint(x: 0 + xPosition, y: 0)
            heartsNodes.append(heartSpriteNode)
            healthBar.addChild(heartsNodes[i])
            i = i + 1
            xPosition = xPosition + 50
        }
    }
    
    //summary
    //setting up projectiles
    func projectileRender()->SKNode{
        let randomSpawnNumber = Int.random(in: 1...4)
        let arrowAsset = SKTexture(imageNamed: "arrow")
        arrowNode = SKSpriteNode(texture: arrowAsset, size: CGSize(width: 50, height: 50))
        arrowNode.name = "projectile"
        arrowNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 20))
        arrowNode.physicsBody?.affectedByGravity = false
        arrowNode.physicsBody?.categoryBitMask = colliderType.projectile
        //randomzing spawnPosition
        if(randomSpawnNumber == 1){
            arrowNode.position = spawnUp
            arrowNode.zRotation = -1.5708
        }
        else if(randomSpawnNumber == 2){
            arrowNode.position = spawnDown
            arrowNode.zRotation = 1.5708
        }
        else if(randomSpawnNumber == 3){
            arrowNode.position = spawnLeft
            arrowNode.zRotation = -0
        }
        else if(randomSpawnNumber == 4){
            arrowNode.position = spawnRight
            arrowNode.zRotation = 3.14159
        }
        
        return arrowNode
    }
    
    func fireProjectileRender()->SKNode{
        let randomSpawnNumber = Int.random(in: 1...4)
        let arrowAsset = SKTexture(imageNamed: "fireball1")
        fireballNode = SKSpriteNode(texture: arrowAsset, size: CGSize(width: 100, height: 100))
        fireballNode.name = "projectile"
        fireballNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 20))
        fireballNode.physicsBody?.affectedByGravity = false
        fireballNode.physicsBody?.categoryBitMask = colliderType.projectile
        //randomzing spawnPosition
        if(randomSpawnNumber == 1){
            fireballNode.position = spawnUp
            fireballNode.zRotation = 1.5708
        }
        else if(randomSpawnNumber == 2){
            fireballNode.position = spawnDown
            fireballNode.zRotation = -1.5708
        }
        else if(randomSpawnNumber == 3){
            fireballNode.position = spawnLeft
            fireballNode.zRotation = 3.14159
        }
        else if(randomSpawnNumber == 4){
            fireballNode.position = spawnRight
            fireballNode.zRotation = 0
        }
        
        return fireballNode
        
    }
    
    //handles removing health when hit by arrow
    func healthHandler(){
        if(heartsNodes.count != 0){
            heartsNodes.last?.removeFromParent()
            heartsNodes.removeLast()
            //this is for the gamerover sequnce
            if(heartsNodes.count == 0){
                let gameOverScene = GameOver(size: CGSize(width: size.width, height: size.height))
                gameOverScene.score = playerScore
                backgroundMusic?.stop()
                self.view?.presentScene(gameOverScene, transition: .fade(withDuration: 0.8))
            }
        }
        //print("ouch that hurt")
    }
    
    func scoreHandler(points:Int){
        
        playerScore = playerScore + points
        scoreLabelNode.text = "Score: " + String(playerScore)
        
        if(playerScore > highScore){
            highScore = playerScore
            highScoreLabelNode.text = "High Score: " + String(highScore)
            highScoreLabelNode.fontName = "PressStart2P-Regular"
            setHighScore()
            
        }
        
    }
    
    
    
    //summary
    //handles the direction for swipe
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        //print(sender.direction)
        if(sender.direction == .up){
            //print("UP")
            shieldNode.position = CGPoint(x: frame.midX, y: frame.midY + 50)
            shieldNode.zRotation = -1.5708
            shieldNode.xScale = 1.0
        }
        if(sender.direction == .down){
            //print("DOWN")
            shieldNode.position = CGPoint(x: frame.midX, y: frame.midY - 50)
            shieldNode.zRotation = 1.5708
            shieldNode.xScale = 1.0
        }
        if(sender.direction == .right){
            //print("RIGHT")
            shieldNode.position = CGPoint(x: frame.midX + 50, y: frame.midY)
            shieldNode.zRotation = 0
            shieldNode.xScale = -1.0
        }
        if(sender.direction == .left){
            //print("LEFT")
            shieldNode.position = CGPoint(x: frame.midX - 50, y: frame.midY)
            shieldNode.zRotation = 0
            shieldNode.xScale = 1.0
        }
        
    }
    
    //summary
    //adding collision detecsion
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
            
        if nodeA?.name == "arrow" && nodeB?.name == "shield" {
            nodeA?.removeFromParent()
            scoreHandler(points: 100)
            //print("arrow made contatc with shield")
        }
        if nodeA?.name == "shield" && nodeB?.name == "arrow" {
            nodeB?.removeFromParent()
            scoreHandler(points: 100)
            //print("arrow made contatc with shield")
        }
        if nodeA?.name == "fireball" && nodeB?.name == "shield" {
            nodeA?.removeFromParent()
            scoreHandler(points: 200)
            //print("arrow made contatc with shield")
        }
        if nodeA?.name == "shield" && nodeB?.name == "fireball" {
            nodeB?.removeFromParent()
            scoreHandler(points: 200)
            //print("arrow made contatc with shield")
        }
        if nodeA?.name == "arrow" && nodeB?.name == "princess" {
            nodeA?.removeFromParent()
            healthHandler()
        }
        if nodeA?.name == "princess" && nodeB?.name == "arrow" {
            nodeB?.removeFromParent()
            healthHandler()
        }
        if nodeA?.name == "fireball" && nodeB?.name == "princess" {
            nodeA?.removeFromParent()
            healthHandler()
        }
        if nodeA?.name == "princess" && nodeB?.name == "fireball" {
            nodeB?.removeFromParent()
            healthHandler()
        }
    }
    
    
}




//
//  ContentView.swift
//  GameDesign
//
//  Created by Javier Bonilla on 4/18/23.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
//    var scene:Game{
//        let scene = Game(size: CGSize(width: screenWidth, height: screenHeight))
//        return scene
//    }
    
    var scene:StartMenu{
        let scene = StartMenu(size: CGSize(width: screenWidth, height: screenHeight))
        return scene
    }
    var body: some View {
        SpriteView(scene: scene)
            .frame(width: screenWidth, height: screenHeight)
            .ignoresSafeArea()
            .statusBarHidden(true)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

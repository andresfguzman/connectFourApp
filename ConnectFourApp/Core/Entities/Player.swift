//
//  Player.swift
//  ConnectFourApp
//
//  Created by Andrés Guzmán on 2/12/19.
//  Copyright © 2019 Andres Felipe Guzman Lopez. All rights reserved.
//

import Foundation
import UIKit

protocol Player {
    var id: Int {get set}
    var name: String {get set}
    var color: UIColor {get set}
    var moves: Int {get set}
    var didWin: Bool {get set}
}

struct RawPlayer: Player {
    var moves: Int
    
    var id: Int
    
    var name: String
    
    var color: UIColor
    
    var didWin: Bool
}

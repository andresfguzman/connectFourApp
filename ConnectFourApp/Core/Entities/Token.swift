//
//  Token.swift
//  ConnectFourApp
//
//  Created by Andrés Guzmán on 2/12/19.
//  Copyright © 2019 Andres Felipe Guzman Lopez. All rights reserved.
//

import UIKit

struct BoardLocation {
    var row: Int
    var col: Int
}

protocol TokenProtocol {
    var player: Player {get set}
    var boardLocation: BoardLocation {get set}
}

struct RawToken: TokenProtocol {
    var player: Player
    var boardLocation: BoardLocation
}

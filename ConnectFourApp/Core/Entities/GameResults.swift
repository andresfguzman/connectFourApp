//
//  GameResults.swift
//  ConnectFourApp
//
//  Created by Andrés Guzmán on 2/14/19.
//  Copyright © 2019 Andres Felipe Guzman Lopez. All rights reserved.
//

import Foundation

protocol GameResults {
    var players: [Player] {get set}
}

struct RawGameResults: GameResults {
    var players: [Player]
}

//
//  Board.swift
//  ConnectFourApp
//
//  Created by Andrés Guzmán on 2/12/19.
//  Copyright © 2019 Andres Felipe Guzman Lopez. All rights reserved.
//

import Foundation

protocol BoardProtocol {
    var tokenSlots: [TokenProtocol] {get set}
}

extension BoardProtocol {
    var rowCount: Int {
        return 7
    }
    
    var colCount: Int {
        return 6
    }
}

struct RawBoard: BoardProtocol {
    var tokenSlots: [TokenProtocol]
}

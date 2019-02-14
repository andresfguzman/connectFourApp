//
//  CheckForWinner.swift
//  ConnectFourApp
//
//  Created by Andrés Guzmán on 2/13/19.
//  Copyright © 2019 Andres Felipe Guzman Lopez. All rights reserved.
//

import Foundation

protocol CheckForWinner {
    func execute(board: BoardProtocol, completion: @escaping (Player) -> Void)
}

final class CheckForWinnerUseCase: CheckForWinner {
    func execute(board: BoardProtocol, completion: @escaping (Player) -> Void) {
        for token in board.tokenSlots {
            if findMatch(token: token, board: board, rowMultiplier: 0, colMultiplier: 1) {
                completion(token.player)
            }
            
            if findMatch(token: token, board: board, rowMultiplier: 1, colMultiplier: 0) {
                completion(token.player)
            }
            
            if findMatch(token: token, board: board, rowMultiplier: 1, colMultiplier: 1) {
                completion(token.player)
            }
            
            if findMatch(token: token, board: board, rowMultiplier: 1, colMultiplier: -1) {
                completion(token.player)
            }
        }
    }
    
    func findMatch(token: TokenProtocol, board: BoardProtocol, rowMultiplier: Int, colMultiplier: Int) -> Bool {
        var startGamePieceType = token
        
        for i in 0..<4 {
            let newRow = token.boardLocation.row + i * rowMultiplier
            let newCol = token.boardLocation.col + i * colMultiplier
            
            let hubToken = board.tokenSlots.first(where: { (token) -> Bool in
                token.boardLocation.row == newRow && token.boardLocation.col == newCol
            })
            if (startGamePieceType.player.color != hubToken?.player.color) {
                return false
            }
        }        
        return true
    }
    
}

//
//  AddTokenToGameBoard.swift
//  ConnectFourApp
//
//  Created by Andrés Guzmán on 2/12/19.
//  Copyright © 2019 Andres Felipe Guzman Lopez. All rights reserved.
//

import Foundation

protocol AddTokenToGameBoard: AnyObject {
    func execute(newToken: TokenProtocol, board: BoardProtocol, completion: @escaping (BoardProtocol, Player?) -> Void)
}

final class AddTokenToGameBoardUseCase: AddTokenToGameBoard {
    var presenter: BoardViewPresenter!
    
    func execute(newToken: TokenProtocol, board: BoardProtocol, completion: @escaping (BoardProtocol, Player?) -> Void) {
        let updatedBoard = addTokenToColumn(token: newToken, board: board)
        completion(updatedBoard.0, updatedBoard.1)
    }
}

private extension AddTokenToGameBoardUseCase {
    func addTokenToColumn(token: TokenProtocol, board: BoardProtocol) -> (BoardProtocol, Player?) {
        var newBoard = board
        var winnerPlayer: Player?
        let boardRowOfInterest = board.tokenSlots.filter { $0.boardLocation.col == token.boardLocation.col }
        if boardRowOfInterest.count < 6 {
            var newToken = token
            newToken.boardLocation.row = boardRowOfInterest.count
            newBoard.tokenSlots.append(newToken)
            let checkWinnerUseCase = CheckForWinnerUseCase()
            checkWinnerUseCase.execute(board: newBoard) { (winner) in
                winnerPlayer = winner
            }
            presenter.switchPlayers()
        }
        return (newBoard, winnerPlayer)
    }
}

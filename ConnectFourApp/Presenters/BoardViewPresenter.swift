//
//  BoardViewPresenter.swift
//  ConnectFourApp
//
//  Created by Andrés Guzmán on 2/12/19.
//  Copyright © 2019 Andres Felipe Guzman Lopez. All rights reserved.
//

import Foundation

protocol BoardViewDelegate: AnyObject {
    func updateCollection()
    func informPlayerSwitched()
    func informWiner(player: Player)
}

final class BoardViewPresenter {
    
    let player1 = RawPlayer(moves: 0, id: 1, name: "Astrolabio", color: .black)
    let player2 = RawPlayer(moves: 0, id: 2, name: "Moises", color: .red)
    
    var board: BoardProtocol!
    var currentPlayer: Player!
    weak var view: BoardViewDelegate!
    
    init(with board: BoardProtocol) {
        self.board = board
        self.currentPlayer = player1
    }
    
    func addToken(toIndex index: IndexPath) {
        let useCase = AddTokenToGameBoardUseCase()
        useCase.presenter = self
        let newToken = RawToken(player: currentPlayer, boardLocation: BoardLocation(row: (board.colCount - 1) - index.section, col: index.row))
        useCase.execute(newToken: newToken, board: board) { [weak self] (newBoard, player) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.currentPlayer.moves += 1
            strongSelf.board = newBoard
            strongSelf.view.updateCollection()
            if let winerPlayer = player {
                strongSelf.view.informWiner(player: winerPlayer)
            }
        }
    }
    
    func player(forIndex index: IndexPath) -> Player? {
        if let tokenSlot = board.tokenSlots.first(where: { $0.boardLocation.col == index.row && $0.boardLocation.row == (board.colCount - 1) - index.section }) {
            return tokenSlot.player.color == player1.color ? player1 : player2
        } else {
            return nil
        }
    }
    
    func switchPlayers() {
        currentPlayer = currentPlayer.id == 1 ? player2 : player1
        view.informPlayerSwitched()
    }
}

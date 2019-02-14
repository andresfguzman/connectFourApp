//
//  BoardViewPresenter.swift
//  ConnectFourApp
//
//  Created by Andrés Guzmán on 2/12/19.
//  Copyright © 2019 Andres Felipe Guzman Lopez. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol BoardViewDelegate: AnyObject {
    func updateCollection()
    func playersChanged(playerOneNick: String, playerTwoNick: String)
    func informPlayerSwitched()
    func informWiner(player: Player)
}

final class BoardViewPresenter {
    
    // Default players:
    var player1: Player = RawPlayer(moves: 0, id: 1, name: "Player 1", color: .black, didWin: false)
    var player2: Player = RawPlayer(moves: 0, id: 2, name: "Player 2", color: .red, didWin: false)
    
    var db: Firestore!
    
    var board: BoardProtocol!
    var currentPlayer: Player!
    var gameResults = [GameResults]()
    weak var view: BoardViewDelegate!
    
    init(with board: BoardProtocol) {
        self.board = board
        self.currentPlayer = player1
        db = Firestore.firestore()
    }
    
    func addToken(toIndex index: IndexPath) {
        let useCase = AddTokenToGameBoardUseCase()
        useCase.presenter = self
        let newToken = RawToken(player: currentPlayer, boardLocation: BoardLocation(row: (board.colCount - 1) - index.section, col: index.row))
        useCase.execute(newToken: newToken, board: board) { [weak self] (newBoard, player) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.board = newBoard
            strongSelf.view.updateCollection()
            if let winnerPlayer = player {
                strongSelf.setPlayerMoves()
                strongSelf.view.informWiner(player: winnerPlayer)
                if winnerPlayer.id == strongSelf.player1.id {
                    strongSelf.player1.didWin = true
                }
                // TODO: this should be a useCase
                strongSelf.saveGameResults(winnerPlayer: winnerPlayer)
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
    
    func setUpPlayers(player1: Player, player2: Player) {
        self.player1 = player1
        self.player2 = player2
        currentPlayer = currentPlayer.id == player1.id ? player1 : player2
        view.playersChanged(playerOneNick: player1.name, playerTwoNick: player2.name)
    }
    
    private func setPlayerMoves() {
        player1.moves = board.tokenSlots.filter { $0.player.id == player1.id }.count
        player2.moves = board.tokenSlots.count - player1.moves
    }
    
    // TODO: This should be called inside a service from a usecase not here
    func saveGameResults(winnerPlayer: Player) {
        var ref: DocumentReference? = nil
        ref = db.collection("finishedGames").addDocument(data:
            [
                "players" : [[
                    "userName": player1.name,
                    "didWin": winnerPlayer.id == player1.id ? true : false,
                    "moves": player1.moves
                    ],
                             ["userName": player2.name,
                              "didWin": winnerPlayer.id == player2.id ? true : false,
                              "moves": player2.moves
                    ]
                ]
            ]
        ) { err in
            if let error = err {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    // TODO: This should be placed inside a use case.
    func getRemoteGameResults(completion: @escaping () -> Void) {
        var gameResults = [GameResults]()
        db.collection("finishedGames").getDocuments { [weak self] (querySnapshot, err) in
            if let error = err {
                print("Error getting document: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    gameResults.append(RawGameResults(players: self?.parsePlayers(dict: document.data()) ?? []))
                }
                self?.gameResults = gameResults
                completion()
            }
        }
    }
    
    func parsePlayers(dict: Dictionary<String, Any>) -> [Player] {
        var resultPlayers = [Player]()
        if let playersArray = dict["players"] as? [[String: Any]] {
            for player in playersArray {
                resultPlayers.append(RawPlayer(moves: player["moves"] as! Int, id: 0, name: player["userName"] as! String, color: .red, didWin: player["didWin"] as! Bool))
            }
        }
        return resultPlayers
    }
}

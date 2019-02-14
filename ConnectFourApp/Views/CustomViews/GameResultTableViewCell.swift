//
//  GameResultTableViewCell.swift
//  ConnectFourApp
//
//  Created by Andrés Guzmán on 2/14/19.
//  Copyright © 2019 Andres Felipe Guzman Lopez. All rights reserved.
//

import UIKit

class GameResultTableViewCell: UITableViewCell {
    @IBOutlet weak var playerOneLabel: UILabel!
    @IBOutlet weak var playerTwoLabel: UILabel!
    @IBOutlet weak var playerOneMoves: UILabel!
    @IBOutlet weak var playerTwoMoves: UILabel!
    @IBOutlet weak var playerOneResult: UILabel!
    @IBOutlet weak var playerTwoResult: UILabel!
    @IBOutlet weak var gameCellTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupTitle(withIteration iteration: Int) {
        gameCellTitle.text = "Game #\(iteration)"
    }
    
    func setUpWithPlayers(player1: Player, player2: Player) {
        playerOneLabel.text = player1.name
        playerOneMoves.text = "Moves: \(player1.moves)"
        playerOneResult.text = "Result: \(player1.didWin == true ? "Winner" : "Loser")"
        
        playerTwoLabel.text = player2.name
        playerTwoMoves.text = "Moves: \(player2.moves)"
        playerTwoResult.text = "Result: \(player2.didWin == true ? "Winner" : "Loser")"
    }
}

//
//  GameResultsViewController.swift
//  ConnectFourApp
//
//  Created by Andrés Guzmán on 2/13/19.
//  Copyright © 2019 Andres Felipe Guzman Lopez. All rights reserved.
//

import UIKit

class GameResultsViewController: UIViewController {

    @IBOutlet weak var resultsTableView: UITableView!
    var presenter: BoardViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getRemoteGameResults(completion: { [weak self] in
            self?.resultsTableView.reloadData()
        })
        resultsTableView.register(UINib.init(nibName: "GameResultCell", bundle: nil), forCellReuseIdentifier: AppConstants.reusableGameCellID)
        // Do any additional setup after loading the view.
    }
}

extension GameResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.gameResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.reusableGameCellID) as! GameResultTableViewCell
        let currentGameResult = presenter.gameResults[indexPath.row]
        let player1 = currentGameResult.players[0]
        let player2 = currentGameResult.players[1]
        cell.setUpWithPlayers(player1: player1, player2: player2)
        cell.setupTitle(withIteration: indexPath.row + 1)
        return cell
    }
}

extension GameResultsViewController: UITableViewDelegate { }

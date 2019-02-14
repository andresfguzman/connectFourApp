//
//  ViewController.swift
//  ConnectFourApp
//
//  Created by Andrés Guzmán on 2/12/19.
//  Copyright © 2019 Andres Felipe Guzman Lopez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var boardCollectionView: UICollectionView!
    @IBOutlet weak var statusDisplayLabel: UILabel!
    @IBOutlet weak var playerTurnIndicatorSegment: UISegmentedControl!
    @IBOutlet weak var replayButton: UIButton!
    var presenter: BoardViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = BoardViewPresenter(with: RawBoard(tokenSlots: []))
        presenter.view = self
        resetUI()
        boardCollectionView.register(UINib.init(nibName: "BoardCellView", bundle: nil), forCellWithReuseIdentifier: AppConstants.reusableCellID)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func resetUI() {
        presenter.board.tokenSlots = []
        presenter.currentPlayer = presenter.player1
        replayButton.isHidden = true
        boardCollectionView.isUserInteractionEnabled = true
        boardCollectionView.reloadData()
        statusDisplayLabel.text = "Connect Four!"
        informPlayerSwitched()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let targetVC = segue.destination as? AuthenticateViewController {
            targetVC.presenter = presenter
        } else if let targetCV = segue.destination as? GameResultsViewController {
            targetCV.presenter = presenter
        }
    }
    
    @IBAction func replayButtonTapped(_ sender: Any) {
        resetUI()
    }
}

// MARK: Collection View Logic
extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.board.colCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.board.rowCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.reusableCellID, for: indexPath) as! BoardViewCell
        if let player = presenter.player(forIndex: indexPath) {
            if player.color == .red {
                cell.tokenImage.image = UIImage(imageLiteralResourceName: "redToken")
            } else {
                cell.tokenImage.image = UIImage(imageLiteralResourceName: "blackToken")
            }
        } else {
            cell.tokenImage.image = nil
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.addToken(toIndex: indexPath)
    }
}

extension ViewController: UICollectionViewDelegate {}

extension ViewController: BoardViewDelegate {
    func playersChanged(playerOneNick: String, playerTwoNick: String) {
        playerTurnIndicatorSegment.setTitle(playerOneNick, forSegmentAt: 0)
        playerTurnIndicatorSegment.setTitle(playerTwoNick, forSegmentAt: 1)
    }
    
    func informWiner(player: Player) {
        statusDisplayLabel.text = "Player \(player.name) has won."
        boardCollectionView.isUserInteractionEnabled = false
        replayButton.isHidden = false
    }
    
    func informPlayerSwitched() {
        playerTurnIndicatorSegment.selectedSegmentIndex = presenter.currentPlayer.id - 1
        if playerTurnIndicatorSegment.selectedSegmentIndex == 0 {
            playerTurnIndicatorSegment.tintColor = .black
        } else {
            playerTurnIndicatorSegment.tintColor = .red
        }
    }
    
    func updateCollection() {
        boardCollectionView.reloadData()
    }
}

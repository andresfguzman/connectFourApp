//
//  AuthenticateViewController.swift
//  ConnectFourApp
//
//  Created by Andrés Guzmán on 2/13/19.
//  Copyright © 2019 Andres Felipe Guzman Lopez. All rights reserved.
//

import UIKit

class AuthenticateViewController: UIViewController {
    @IBOutlet weak var playerOneNicknameTextView: UITextField!
    @IBOutlet weak var playerTwoNicknameTextView: UITextField!
    
    var presenter: BoardViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logInPlayers(_ sender: Any) {
        
        guard let playerOneNick = playerOneNicknameTextView.text, let playerTwoNick = playerTwoNicknameTextView.text else {
            return
        }
        
        let player1 = RawPlayer(moves: 0, id: 1, name: playerOneNick, color: .black, didWin: false)
        let player2 = RawPlayer(moves: 0, id: 2, name: playerTwoNick, color: .red, didWin: false)
        
        presenter.setUpPlayers(player1: player1, player2: player2)
        dismiss(animated: true, completion: nil)
    }
}

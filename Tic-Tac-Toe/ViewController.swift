//
//  ViewController.swift
//  Tic-Tac-Toe
//
//  Created by Brijesh Ajudia on 08/08/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var lblTurn: UILabel!
    
    @IBOutlet weak var btnA1: UIButton!
    @IBOutlet weak var btnA2: UIButton!
    @IBOutlet weak var btnA3: UIButton!
    
    @IBOutlet weak var btnB1: UIButton!
    @IBOutlet weak var btnB2: UIButton!
    @IBOutlet weak var btnB3: UIButton!
    
    @IBOutlet weak var btnC1: UIButton!
    @IBOutlet weak var btnC2: UIButton!
    @IBOutlet weak var btnC3: UIButton!
    
    var firstTurn = Turn.Cross
    var currentTurn = Turn.Cross
    
    var board = [UIButton]()
    
    var noughtsScore: Int = 0
    var crossesScore: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        initBoard()
    }
    
    func initBoard() {
        self.board.append(btnA1)
        self.board.append(btnA2)
        self.board.append(btnA3)
        self.board.append(btnB1)
        self.board.append(btnB2)
        self.board.append(btnB3)
        self.board.append(btnC1)
        self.board.append(btnC2)
        self.board.append(btnC3)
    }
    
    func addToBoard(_ sender: UIButton) {
        if (sender.currentTitle ?? "") == "" {
            if self.currentTurn == Turn.Nought {
                sender.setTitle(Player.NOUGHT, for: .normal)
                self.currentTurn = Turn.Cross
                self.lblTurn.text = Player.CROSS
            }
            else if self.currentTurn == Turn.Cross {
                sender.setTitle(Player.CROSS, for: .normal)
                self.currentTurn = Turn.Nought
                self.lblTurn.text = Player.NOUGHT
            }
            sender.isEnabled = false
        }
    }

    func fullBoard() -> Bool {
        for button in self.board {
            if (button.currentTitle ?? "") == "" {
                return false
            }
        }
        return true
    }
    
    func showAlert(title: String) {
        let message = "\nNoughts " + String(self.noughtsScore) + "\n\nCrosses " + String(self.crossesScore)
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Reset", style: .default, handler: { (_) in
            self.resetBoard()
        }))
        self.present(ac, animated: true)
    }
    
    func resetBoard() {
        for button in self.board {
            button.setTitle("", for: .normal)
            button.isEnabled = true
        }
        
        if self.firstTurn == .Nought {
            self.firstTurn = .Cross
            self.lblTurn.text = Player.CROSS
        }
        else if self.firstTurn == .Cross {
            self.firstTurn = .Nought
            self.lblTurn.text = Player.NOUGHT
        }
        self.currentTurn = self.firstTurn
    }
    
    func checkVictory(str: String) -> Bool {
        
        // Horizontal Victory
        if (self.thisSymbol(self.btnA1, str)) && (self.thisSymbol(self.btnA2, str)) && (self.thisSymbol(self.btnA3, str)) {
            return true
        }
        if (self.thisSymbol(self.btnB1, str)) && (self.thisSymbol(self.btnB2, str)) && (self.thisSymbol(self.btnB3, str)) {
            return true
        }
        if (self.thisSymbol(self.btnC1, str)) && (self.thisSymbol(self.btnC2, str)) && (self.thisSymbol(self.btnC3, str)) {
            return true
        }
        
        // Vertical Victory
        if (self.thisSymbol(self.btnA1, str)) && (self.thisSymbol(self.btnB1, str)) && (self.thisSymbol(self.btnC1, str)) {
            return true
        }
        if (self.thisSymbol(self.btnA2, str)) && (self.thisSymbol(self.btnB2, str)) && (self.thisSymbol(self.btnC2, str)) {
            return true
        }
        if (self.thisSymbol(self.btnA3, str)) && (self.thisSymbol(self.btnB3, str)) && (self.thisSymbol(self.btnC3, str)) {
            return true
        }
        
        // Diagonal Victory
        if (self.thisSymbol(self.btnA1, str)) && (self.thisSymbol(self.btnB2, str)) && (self.thisSymbol(self.btnC3, str)) {
            return true
        }
        if (self.thisSymbol(self.btnA3, str)) && (self.thisSymbol(self.btnB2, str)) && (self.thisSymbol(self.btnC1, str)) {
            return true
        }
        
        return false
    }
    
    func thisSymbol(_ button: UIButton, _ symbol: String) -> Bool {
        return (button.currentTitle ?? "") == symbol
    }

}

extension ViewController {
    // All Buttons Action
    @IBAction func tapAction(_ sender: UIButton) {
        self.addToBoard(sender)
        
        if self.checkVictory(str: Player.CROSS) {
            self.crossesScore += 1
            self.showAlert(title: "Crosses Wins!")
        }
        else if self.checkVictory(str: Player.NOUGHT) {
            self.noughtsScore += 1
            self.showAlert(title: "Noughts Wins!")
        }
        
        if self.fullBoard() {
            showAlert(title: "Draw")
        }
    }
}

enum Turn {
    case Cross
    case Nought
}

struct Player {
    static let NOUGHT = "O"
    static let CROSS = "X"
}



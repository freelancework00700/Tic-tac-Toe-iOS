//
//  DynamicVC.swift
//  Tic-Tac-Toe
//
//  Created by Brijesh Ajudia on 09/08/24.
//

import UIKit

class DynamicVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var clvDynamic: UICollectionView!
    @IBOutlet weak var lblTurn: UILabel!
        
        var firstTurn = Turn.Cross
        var currentTurn = Turn.Cross
        
        var board: [String] = []
        var gridSize: Int = 10 // Change this for a different grid size
        var winCondition: Int = 5 // Number of symbols in a row to win
        
        var noughtsScore: Int = 0
        var crossesScore: Int = 0

        override func viewDidLoad() {
            super.viewDidLoad()
            clvDynamic.delegate = self
            clvDynamic.dataSource = self
            clvDynamic.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DynamicCVCell")
            self.resetBoard()
        }
        
        func resetBoard() {
            self.board = Array(repeating: "", count: gridSize * gridSize)
            self.currentTurn = firstTurn
            self.lblTurn.text = (firstTurn == .Cross) ? Player.CROSS : Player.NOUGHT
            self.clvDynamic.reloadData()
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.gridSize * self.gridSize
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DynamicCVCell", for: indexPath)
            
            for subview in cell.contentView.subviews {
                subview.removeFromSuperview()
            }
            
            let label = UILabel(frame: cell.contentView.frame)
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 21, weight: .heavy)
            label.text = board[indexPath.item]
            cell.contentView.addSubview(label)
            
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if self.board[indexPath.item] == "" {
                self.board[indexPath.item] = (self.currentTurn == .Cross) ? Player.CROSS : Player.NOUGHT
                self.currentTurn = (self.currentTurn == .Cross) ? .Nought : .Cross
                lblTurn.text = (self.currentTurn == .Cross) ? Player.CROSS : Player.NOUGHT
                collectionView.reloadItems(at: [indexPath])
                
                if self.checkVictory(for: Player.CROSS) {
                    self.crossesScore += 1
                    self.showAlert(title: "Crosses Wins!")
                } else if self.checkVictory(for: Player.NOUGHT) {
                    self.noughtsScore += 1
                    self.showAlert(title: "Noughts Wins!")
                } else if self.fullBoard() {
                    self.showAlert(title: "Draw")
                }
            }
        }
        
        func checkVictory(for symbol: String) -> Bool {
            // Check rows
            for row in 0..<self.gridSize {
                for col in 0..<(self.gridSize - self.winCondition + 1) {
                    if (0..<self.winCondition).allSatisfy({ self.board[row * self.gridSize + col + $0] == symbol }) {
                        return true
                    }
                }
            }
            
            // Check columns
            for col in 0..<self.gridSize {
                for row in 0..<(self.gridSize - self.winCondition + 1) {
                    if (0..<self.winCondition).allSatisfy({ self.board[(row + $0) * self.gridSize + col] == symbol }) {
                        return true
                    }
                }
            }
            
            // Check diagonals (top-left to bottom-right)
            for row in 0..<(self.gridSize - self.winCondition + 1) {
                for col in 0..<(self.gridSize - self.winCondition + 1) {
                    if (0..<self.winCondition).allSatisfy({ self.board[(row + $0) * self.gridSize + col + $0] == symbol }) {
                        return true
                    }
                }
            }
            
            // Check diagonals (bottom-left to top-right)
            for row in (self.winCondition - 1)..<self.gridSize {
                for col in 0..<(self.gridSize - self.winCondition + 1) {
                    if (0..<self.winCondition).allSatisfy({ self.board[(row - $0) * self.gridSize + col + $0] == symbol }) {
                        return true
                    }
                }
            }
            
            return false
        }
        
        func fullBoard() -> Bool {
            return !self.board.contains("")
        }
        
        func showAlert(title: String) {
            let message = "\nNoughts \(self.noughtsScore)\n\nCrosses \(self.crossesScore)"
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "Reset", style: .default, handler: { (_) in
                self.resetBoard()
            }))
            self.present(ac, animated: true)
        }
        
        // Collection view layout customization
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let size = collectionView.frame.size.width / CGFloat(self.gridSize) - 10
            return CGSize(width: size, height: size)
        }

}

//
//  ProblemViewController.swift
//  Travelling Salesman
//
//  Created by Maria Semakova on 11/6/17.
//  Copyright © 2017 Maria Semakova. All rights reserved.
//

import UIKit

class ProblemViewController: UIViewController {

    @IBOutlet weak var updateMatrixButton: UIButton!
    @IBOutlet weak var calculateCheapestPathButton: UIButton!
    
    @IBOutlet weak var numberOfCitiesTextField: UITextField!
    @IBOutlet weak var pathLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    @IBOutlet weak var matrixView: UIView!
    
    let minNumberOfCities : Int = 1
    let maxNumberOfCities : Int = 10
    
    var matrix : Matrix?
    var cellLabels : [MatrixCellLabel] = []
    
    var TSPSolver : TSPPathFinder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func updateMatrix(_ sender: UIButton) {
        
        guard let text = numberOfCitiesTextField.text else { return }
        guard let numberOfCities: Int = Int(text),
            minNumberOfCities ... maxNumberOfCities ~= numberOfCities  else {
                wrongNumberOfCitites()
                return
        }
        matrix = Matrix(rows: numberOfCities, cols: numberOfCities)
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        DispatchQueue.main.async {
            self.pathLabel.text = nil
            self.costLabel.text = nil
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.clearMatrix()
            self.showMatrix()
        }
    }
    
    @IBAction func calculateCheapestPath(_ sender: UIButton) {
        
        guard let matrix = matrix else {
            print("No available matrix")
            return
        }
        
        TSPSolver = TSPPathFinder(matrix: matrix)
        guard let (cheapestPath, cost) = TSPSolver?.solveTSP() else {
            print("Cheapest path cannot be calculated")
            return
        }
        let stringCheapestPath = cheapestPath.flatMap { "C" + String(describing: $0) }.joined(separator: " -> ")
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        DispatchQueue.main.async {
            self.pathLabel.text = stringCheapestPath
            self.costLabel.text = "Стоимость: \(cost)"
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.clearMatrix()
            self.showMatrix()
        }
    }
    
    private func wrongNumberOfCitites() {
        let alertMessageController = UIAlertController(title: "Неверное число городов", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alertMessageController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertMessageController, animated: true, completion: nil)
        }
    }
    
    private func showMatrix() {
        guard let colNumber = matrix?.cols, let rowNumber = matrix?.rows else { return }
        let squareLabelSize = matrixView.frame.width / CGFloat(colNumber + 1)
        let cellLabelSize = CGSize(width: squareLabelSize, height: squareLabelSize)
        showMatrixCells(colNumber: colNumber, rowNumber: rowNumber, cellLabelSize: cellLabelSize)
        showSideCells(colNumber: colNumber, rowNumber: rowNumber, labelSize: cellLabelSize)
    }
    
    private func clearMatrix() {
        for view in matrixView.subviews {
            view.removeFromSuperview()
        }
    }
    
    private func showMatrixCells(colNumber: Int, rowNumber: Int, cellLabelSize: CGSize) {
        for row in 0..<rowNumber {
            for col in 0..<colNumber {
                guard let cell = matrix?.cells[row][col] else { return }
                let cellLabel : MatrixCellLabel = MatrixCellLabel(cell: cell, cellSize: cellLabelSize)
                cellLabel.configure(row: row, col: col)
                matrixView.addSubview(cellLabel)
            }
        }
    }
    
    private func showSideCells(colNumber: Int, rowNumber: Int, labelSize: CGSize) {
        
        let cornerLabel = SideLabel(text: "-", row: 0, col: 0, labelSize: labelSize)
        matrixView.addSubview(cornerLabel)
        
        for col in 1...colNumber {
            let sideLabel = SideLabel(text: "C\(col - 1)", row: 0, col: col, labelSize: labelSize)
            matrixView.addSubview(sideLabel)
        }
        
        for row in 1...rowNumber {
            let sideLabel = SideLabel(text: "C\(row - 1)", row: row, col: 0, labelSize: labelSize)
            matrixView.addSubview(sideLabel)
        }
    }
}

//
//  SolutionViewController.swift
//  Travelling Salesman
//
//  Created by Maria Semakova on 11/18/17.
//  Copyright © 2017 Maria Semakova. All rights reserved.
//

import UIKit

class SolutionViewController: UIViewController {
    
    @IBOutlet weak var pathLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    @IBOutlet weak var matrixView: UIView!
    
    var matrix : Matrix?
    var cellLabels : [MatrixCellLabel] = []
    var model : SolutionModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let closeButton = UIBarButtonItem.init(title: "Закрыть", style: .done, target: self, action: #selector(closeButtonTapped))
        self.navigationItem.leftBarButtonItem = closeButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setModel(solution: SolutionModel) {
        
        model = solution
        matrix = solution.matrix
        
    }
    
    func setup() {
        let cost = self.model?.cost ?? INT32_MAX
        DispatchQueue.main.async {
            self.showMatrix()
            self.pathLabel.text = self.model?.cheapestPath
            self.costLabel.text = "Стоимость: \(cost)"
        }
    }
    
    // MARK: - Private methods
    
    // MARK: - UI related
    
    @objc private func closeButtonTapped() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func showMatrix() {
        guard let colNumber = matrix?.cols, let rowNumber = matrix?.rows else { return }
        let squareLabelSize = matrixView.frame.width / CGFloat(colNumber + 1)
        let cellLabelSize = CGSize(width: squareLabelSize, height: squareLabelSize)
        showMatrixCells(colNumber: colNumber, rowNumber: rowNumber, cellLabelSize: cellLabelSize)
        showSideCells(colNumber: colNumber, rowNumber: rowNumber, labelSize: cellLabelSize)
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

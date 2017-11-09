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
    
    @IBOutlet weak var matrixView: UIView!
    
    let minNumberOfCities : Int = 1
    let maxNumberOfCities : Int = 10
    
    var matrix : Matrix?
    var cellLabels : [MatrixCellLabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        clearMatrix()
        self.matrix = Matrix(cols: numberOfCities, rows: numberOfCities)
        showMatrix()
    }
    
    @IBAction func calculateCheapestPath(_ sender: UIButton) {
    }
    
    func wrongNumberOfCitites() {
        let alertMessageController = UIAlertController(title: "Неверное число городов", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alertMessageController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertMessageController, animated: true, completion: nil)
        }
    }
    
    func showMatrix() {
        guard let colNumber = self.matrix?.cols, let rowNumber = self.matrix?.rows else { return }
        let cellLabelSize = self.matrixView.frame.width / CGFloat(colNumber)
        
        for row in 0..<rowNumber {
            for col in row..<colNumber {
                guard let cell = matrix?.cells[row][col] else { return }
                let cellLabel : MatrixCellLabel = MatrixCellLabel(cell: cell, cellSize: cellLabelSize)
                cellLabel.text = String(cell.cost)
                cellLabel.contentMode = .center
                self.matrixView.addSubview(cellLabel)
                
                guard let symcell = matrix?.cells[col][row] else { return }
                let symcellLabel : MatrixCellLabel = MatrixCellLabel(cell: symcell, cellSize: cellLabelSize)
                symcellLabel.text = String(symcell.cost)
                symcellLabel.contentMode = .center
                self.matrixView.addSubview(symcellLabel)
            }
        }
    }
    
    func clearMatrix() {
        for view in self.matrixView.subviews {
            view.removeFromSuperview()
        }
    }
}

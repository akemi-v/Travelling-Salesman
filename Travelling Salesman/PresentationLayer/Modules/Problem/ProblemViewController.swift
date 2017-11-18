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
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var numberOfCitiesTextField: UITextField!
    @IBOutlet weak var pathLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    @IBOutlet weak var matrixView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let minNumberOfCities : Int = 1
    let maxNumberOfCities : Int = 10
    
    var matrix : Matrix?
    var cellLabels : [MatrixCellLabel] = []
    
    var TSPSolver : TSPPathFinder?
    
    var solutionService : ISolutionService!
    
    func setDependencies(solutionService: ISolutionService) {
        self.solutionService = solutionService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true
        configureButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearMatrix()
        self.showMatrix()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    
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
        
        activityIndicator.startAnimating()
        self.stackView.alpha = 0.5
        self.matrixView.subviews.forEach { $0.isHidden = true }
        
        guard let matrix = matrix else {
            print("No available matrix")
            return
        }
        
        TSPSolver = TSPPathFinder(matrix: matrix)
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let (cheapestPath, cost) = self.TSPSolver?.solveTSP() else {
                print("Cheapest path cannot be calculated")
                return
            }
            
            let stringCheapestPath = cheapestPath.flatMap { "C" + String(describing: $0) }.joined(separator: " → ")
            
            let solutionModel = SolutionModel(matrix: matrix, cheapestPath: stringCheapestPath, cost: cost, date: Date())
            self.saveSolution(solution: solutionModel)
            
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            
            DispatchQueue.main.async {
                self.stackView.alpha = 1.0
                self.matrixView.subviews.forEach { $0.isHidden = false }
                self.activityIndicator.stopAnimating()
                self.pathLabel.text = stringCheapestPath
                self.costLabel.text = "Стоимость: \(cost)"
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) {
                self.clearMatrix()
                self.showMatrix()
            }

        }
    }
    
    // MARK: - Private methods
    
    private func wrongNumberOfCitites() {
        let alertMessageController = UIAlertController(title: "Неверное число городов", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alertMessageController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertMessageController, animated: true, completion: nil)
        }
    }
    
    // MARK: - UI related
    
    private func configureButtons() {
        let usedColor = UIColor(red: 99/255, green: 69/255, blue: 69/255, alpha: 1.0)
        
        updateMatrixButton.layer.masksToBounds = true
        updateMatrixButton.layer.cornerRadius = 10
        updateMatrixButton.layer.borderWidth = 1
        updateMatrixButton.layer.borderColor = usedColor.cgColor
        updateMatrixButton.setTitleColor(UIColor .black, for: .normal)
        updateMatrixButton.backgroundColor = UIColor(red: 227/255, green: 193/255, blue: 194/255, alpha: 1.0)
        
        
        calculateCheapestPathButton.layer.masksToBounds = true
        calculateCheapestPathButton.layer.cornerRadius = 10
        calculateCheapestPathButton.layer.borderWidth = 1
        calculateCheapestPathButton.layer.borderColor = usedColor.cgColor
        calculateCheapestPathButton.setTitleColor(UIColor .black, for: .normal)
        calculateCheapestPathButton.backgroundColor = UIColor(red: 222/255, green: 209/255, blue: 177/255, alpha: 1.0)

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
                cellLabel.adjustsFontSizeToFitWidth = true
                cellLabel.minimumScaleFactor = 0.1
                matrixView.addSubview(cellLabel)
            }
        }
    }
    
    private func showSideCells(colNumber: Int, rowNumber: Int, labelSize: CGSize) {
        
        let cornerLabel = SideLabel(text: "-", row: 0, col: 0, labelSize: labelSize)
        matrixView.addSubview(cornerLabel)
        
        for col in 1...colNumber {
            let sideLabel = SideLabel(text: "C\(col - 1)", row: 0, col: col, labelSize: labelSize)
            sideLabel.adjustsFontSizeToFitWidth = true
            sideLabel.minimumScaleFactor = 0.1
            matrixView.addSubview(sideLabel)
        }
        
        for row in 1...rowNumber {
            let sideLabel = SideLabel(text: "C\(row - 1)", row: row, col: 0, labelSize: labelSize)
            sideLabel.adjustsFontSizeToFitWidth = true
            sideLabel.minimumScaleFactor = 0.1
            matrixView.addSubview(sideLabel)
        }
    }
    
    // MARK: - Saving into storage
    
    private func saveSolution(solution: SolutionModel) {
        let failure : (String?) -> Void = prepareFailureAlert(activateSaving: { [weak self] in
            self?.saveSolution(solution: solution) })
        let saveCompletionHandler : (String?) -> Void = { error in
            if error != nil {
                failure(error)
            }
        }
        solutionService.saveSolution(solution: solution, completionHandler: saveCompletionHandler)
    }
    
    private func prepareFailureAlert(activateSaving: @escaping () -> Void) -> ((String?) -> Void) {
        let failure = { [weak self] (error: String?) in
            
            let alertMessageController = UIAlertController(title: "Ошибка", message: error, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ок", style: .default)
            let retryAction = UIAlertAction(title: "Повторить", style: .default, handler: { _ in
                activateSaving()
            })
            alertMessageController.addAction(okAction)
            alertMessageController.addAction(retryAction)
            DispatchQueue.main.async {
                self?.present(alertMessageController, animated: true, completion: nil)
            }
        }
        return failure
    }

}

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
    
    let maxCost : UInt32 = 100
    let minNumberOfCities : Int = 1
    let maxNumberOfCities : Int = 10
    
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
    }
    
    @IBAction func calculateCheapestPath(_ sender: UIButton) {
    }
    
    func randomCost() -> Int {
        return Int(arc4random_uniform(maxCost) + 1)
    }
    
    func wrongNumberOfCitites() {
        let alertMessageController = UIAlertController(title: "Неверное число городов", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alertMessageController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertMessageController, animated: true, completion: nil)
        }
    }
}

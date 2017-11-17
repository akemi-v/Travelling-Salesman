//
//  HistoryViewController.swift
//  Travelling Salesman
//
//  Created by Maria Semakova on 11/6/17.
//  Copyright © 2017 Maria Semakova. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var solutionLabel: UILabel!
    
    var solutionService : ISolutionService!
    var solutions : [SolutionModel] = []
    
    let dateFormatter = DateFormatter()
    
    func setDependencies(solutionService: ISolutionService) {
        self.solutionService = solutionService
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss"

        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadSolutions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private methods
    
    private func setup(datasource: [SolutionModel]) {
        solutions = datasource
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Loading from the storage
    
    private func loadSolutions() {
        let failure : (String?) -> Void = prepareFailureAlert(activateSaving: { [weak self] in
            self?.loadSolutions() })
        
        let setSolutions : ([SolutionModel]?, String?) -> Void = { [weak self] (fetchedSolutions, error) in
            guard let solutions = fetchedSolutions else {
                failure(error)
                return
            }
            
            self?.setup(datasource: solutions)
        }
        
        solutionService.loadSolutions(completionHandler: setSolutions)
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

// MARK: - UITableViewDataSource

extension HistoryViewController : UITableViewDataSource {
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return solutions.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let identifier = "SolutionCellIdentifier"
        var cell : UITableViewCell
        
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: identifier) {
            cell = dequeuedCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        let date = solutions[indexPath.row].date
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = dateFormatter.string(from: date as Date)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HistoryViewController : UITableViewDelegate {
    
}

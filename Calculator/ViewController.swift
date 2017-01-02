//
//  ViewController.swift
//  Calculator
//
//  Created by Nate Thompson on 12/25/16.
//  Copyright © 2016 Nate Thompson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    let calculations: CalculationDelegate = DefaultCalculationDelegate()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var resultLabel: UILabel!

    @IBAction func numberButtonPressed(_ sender: UIButton) {
        let buttonTitle = sender.titleLabel!.text!
        let buttonNumber = Int(buttonTitle)! //converts string to int
        calculations.handleInput(buttonNumber)
        
        //also update the text on screen
        print(calculations.resultNumber)
        print(calculations.resultNumber.roundedString)
        resultLabel.text = calculations.resultNumber.roundedString
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {
        setOperator("+", withFunction: +)
    }
    
    @IBAction func subtractButtonPressed(_ sender: UIButton) {
        setOperator("-", withFunction: -)
    }
    
    @IBAction func multiplyButtonPressed(_ sender: UIButton) {
        setOperator("*", withFunction: *)
    }
    
    @IBAction func divideButtonPressed(_ sender: UIButton) {
        setOperator("/", withFunction: /)
    }
    
    @IBAction func equalsButtonPressed(_ sender: UIButton) {
        calculations.clearInputAndSave(true)
        resultLabel.text = calculations.resultNumber.roundedString
        reloadTable()
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        calculations.clearInputAndSave(false)
        resultLabel.text = calculations.resultNumber.roundedString
        reloadTable()
    }
    
    func setOperator(_ character: String, withFunction function: @escaping (Double, Double) -> (Double)) {
        //DefaultOperator is part of the default CalculationDelegate
        let customOperator = DefaultOperator(forCharacter: character, withFunction: function)
        calculations.setOperator(customOperator)
        
        //again, update the text on screen
        resultLabel.text = calculations.resultNumber.roundedString
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calculations.previousExpressions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.item
        let (expression, result) = calculations.previousExpressions[index]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "paperTapeCell") as! PaperTapeCell
        cell.customize(expression + " " + result)
        return cell
    }
    
    func reloadTable() {
        tableView.reloadData()
        
        let lastIndex = calculations.previousExpressions.count - 1
        let indexPath = IndexPath(item: lastIndex, section: 0)
        if lastIndex > 0 {
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
}

class PaperTapeCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!

    
    func customize(_ customString: String) {
        label.text = customString
    }
}


//
//  MyQuestionViewController.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 10/29/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit

class MyQuestionsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    
    lazy var questions = self.currentUser!.questionsByDate
    
    var dateFormatter: DateFormatter = {
        // Create
        let dateFormatter = DateFormatter()
        
        // Set up
        dateFormatter.locale = Locale(identifier: "es_MX")
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        return dateFormatter
    }()
    
    // MARK: Core Data
    
    var currentUser: User!
    
    
    // MARK: - Actions
    
    /**
     Returns to the generalVC.
     
     - Parameter sender: Button that triggered the action.
     */
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation

    /**
     Prepares the controller to perform the segue.
     
     - Parameter segue: Segue's type.
     - Parameter sender: View controller that presents.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}

// MARK: - TableView Data Source

extension MyQuestionsViewController: UITableViewDataSource {
    
    /**
     Indicates the number of rows for a given section.
     
     - Parameter tableView: TableView object.
     - Parameter section: Section to query.
     - Returns: Total of rows for section.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let questions = self.questions {
            return questions.count
        } else {
            return 0
        }
    }
    
    /**
     Formats a cell in the tableView.
     
     - Parameter tableView: TableView object.
     - Parameter indexPath: Current position of cell.
     - Returns: Cell ready to display.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get reusable cell
        let questionCell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! QuestionTableViewCell
        
        // Get question
        if let question = self.questions?[indexPath.row] {
            // Set up
            questionCell.labelDate.text = self.dateFormatter.string(from: question.createdAt!)
            questionCell.labelReport.text = "\(question.reports)"
            questionCell.labelCategory.text = question.category
            questionCell.labelContent.text = question.content
            questionCell.labelLike.text = "\(question.likes)"
            
            if let answers = question.answers {
                questionCell.labelMessages.text = "\(answers.count)"
            } else {
                questionCell.labelMessages.text = "0"
            }
            
            if question.likes == 0 {
                questionCell.imageViewLike.image = UIImage(named: "no-like")
            } else {
                questionCell.imageViewLike.image = UIImage(named: "like")
            }
        }
        
        return questionCell
    }
    
}

// MARK: - TableView Delegate

extension MyQuestionsViewController: UITableViewDelegate {
    
    /**
     Deselects a row when the user taps on it.
     
     - Parameter tableView: TableView object.
     - Parameter indexPath: Position of the tapped cell.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

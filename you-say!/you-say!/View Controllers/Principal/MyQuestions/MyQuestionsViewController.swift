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
    var dateFormatter: DateComponentsFormatter!
    
    lazy var refreshControl: UIRefreshControl = {
        // Create
        let refreshControl = UIRefreshControl()
        
        // Set up
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: Core Data
    
    var currentUser: User!
    
    
    // MARK: - View Life Cycle
    
    /**
     Reloads the tableView to display new data.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    /**
     Initial set up for the view controller.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial set up
        setupViews()
    }
    
    // MARK: Set up
    
    /**
     Adds initial features for views.
     */
    private func setupViews() {
        // Pull to refresh
        self.tableView.addSubview(self.refreshControl)
    }
    
    
    // MARK: - Helper Methods
    
    /**
     Refreshes the tableView when the user pulls.
     
     - Parameter sender: Refresh object that is sent.
     */
    @objc func handleRefresh(_ sender: UIRefreshControl) {
        self.tableView.reloadData()
        sender.endRefreshing()
    }
    
    
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
        switch segue.identifier {
        case "answerSegue":
            // Get indexPath
            if let indexPath = self.tableView.indexPathForSelectedRow {
                // Get active question
                let question = self.questions![indexPath.row]
                
                // Pass data to destination
                let myAnswersVC = segue.destination as! MyAnswersViewController
                myAnswersVC.question = question
                myAnswersVC.dateFormatter = self.dateFormatter
                myAnswersVC.currentUser = self.currentUser
            }
            
        default:
            return
        }
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
            // Calculate time interval
            let interval = self.dateFormatter.string(from: question.createdAt!, to: Date())
            
            // Set up
            questionCell.labelDate.text = "Hace \(interval!)"
            questionCell.labelReport.text = "\(question.reports)"
            questionCell.textFieldCategory.text = question.category
            questionCell.labelContent.text = question.content
            questionCell.labelLike.text = "\(question.likes)"
            
            // Conditional components
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

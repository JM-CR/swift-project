//
//  MainViewController.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 10/29/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class GeneralViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelNullDescription: UILabel!
    
    // MARK: Properties
    
    lazy var currentUser = (self.tabBarController as! NavigationViewController).currentUser!
    
    var haveQuestions: Bool {
        guard let questions = self.fetchedResultsController.fetchedObjects else {
            return false
        }
        return questions.count > 0 ? true : false
    }
    
    var dateFormatter: DateComponentsFormatter = {
        // Create
        let formatter = DateComponentsFormatter()
        
        // Set up
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 1
        
        return formatter
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        // Create
        let refreshControl = UIRefreshControl()
        
        // Set up
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: Core Data
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Question> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Question> = Question.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Question.createdAt), ascending: false)]
        
        if let filters = self.currentUser.filtersAsArray {
            let categories: [String] = filters.compactMap { $0.category }
            fetchRequest.predicate = NSPredicate(format: "category IN %@", categories)
        }
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.currentUser.managedObjectContext!,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    // MARK: Core Location
    
    
    // MARK: - View Life Cycle
    
    /**
     Initial set up for the view controller.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial set up
        setupViews()
        fetchQuestions()
        updateView()
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
     Synchronizes the view with the model.
     */
    private func updateView() {
        if self.haveQuestions {
            self.tableView.isHidden = false
            self.labelNullDescription.isHidden = true
        } else {
            self.tableView.isHidden = true
            self.labelNullDescription.isHidden = false
        }
    }
    
    /**
     Retrieves questions from Core Data.
     */
    private func fetchQuestions() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            showAlert(
                title: "No se pudo contactar al servidor",
                message: "Intenta conectarte más tarde"
            )
        }
    }
    
    /**
     Refreshes the tableView when the user pulls.
     
     - Parameter sender: Refresh object that is sent.
     */
    @objc func handleRefresh(_ sender: UIRefreshControl) {
        self.tableView.reloadData()
        sender.endRefreshing()
    }
    
    
    // MARK: - Navigation

    /**
     Prepares the controller to perform the segue.
     
     - Parameter segue: Segue's type.
     - Parameter sender: View controller that presents.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "filterSegue":
            // Get parent controller
            guard let navigationVC = self.tabBarController as? NavigationViewController else { return }
            
            // Pass data to destination
            let filtersVC = segue.destination as! FiltersViewController
            filtersVC.currentUser = self.currentUser
            filtersVC.categories = navigationVC.categories
            filtersVC.delegate = self
            
        case "myQuestionsSegue":
            // Pass data to destination
            let myQuestionsVC = segue.destination as! MyQuestionsViewController
            myQuestionsVC.currentUser = self.currentUser
            myQuestionsVC.dateFormatter = self.dateFormatter
            
        case "myAnswersSegue":
            // Pass data to destination
            let myAnswersVC = segue.destination as! MyAnswersViewController
            myAnswersVC.question = self.fetchedResultsController.object(at: self.tableView.indexPathForSelectedRow!)
            myAnswersVC.dateFormatter = self.dateFormatter
            myAnswersVC.currentUser = self.currentUser
            
        default:
            return
        }
    }

}

// MARK: - TableView Data Source

extension GeneralViewController: UITableViewDataSource {
    
    /**
     Indicates the number of rows for a given section.
     
     - Parameter tableView: TableView object.
     - Parameter section: Section to query.
     - Returns: Total of rows for section.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = self.fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
    }
    
    /**
     Formats a cell in the tableView.
     
     - Parameter tableView: TableView object.
     - Parameter indexPath: Current position of cell.
     - Returns: Cell ready to display.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get reusable cell
        let generalCell = tableView.dequeueReusableCell(withIdentifier: "generalCell", for: indexPath) as! GeneralTableViewCell
        
        // Set up cell
        configure(generalCell, at: indexPath)
        
        return generalCell
    }
    
    /**
     Configures the displayed cell at the given indexPath.
     
     - Parameter generalCell: Object.
     - Parameter indexPath: Current position of the cell.
     */
    func configure(_ generalCell: GeneralTableViewCell, at indexPath: IndexPath) {
        // Fetch Note
        let question = self.fetchedResultsController.object(at: indexPath)
        
        // General set up
        generalCell.labelContent.text = question.content
        generalCell.labelTotalLikes.text = "\(question.likes)"
        generalCell.textFieldCategory.text = question.category
        generalCell.labelTotalMesssages.text = "\(question.answers?.count ?? 0)"
        
        // Time from publish date
        let interval = self.dateFormatter.string(from: question.createdAt!, to: Date())
        generalCell.labelDate.text = "Hace \(interval!)"
        
        // Get username
        if let alias = question.user?.alias, !alias.isEmpty {
            generalCell.labelUser.text = "\(question.user!.name!) <\(alias)>"
        } else {
            generalCell.labelUser.text = question.user!.name
        }
        
        // Set image
        if question.likes == 0 {
            generalCell.imageViewLike.image = UIImage(named: "no-like")
        } else {
            generalCell.imageViewLike.image = UIImage(named: "like")
        }
    }
    
}

// MARK: - TableView Delegate

extension GeneralViewController: UITableViewDelegate {
    
    /**
     Deselects a row when the user taps on it.
     
     - Parameter tableView: TableView object.
     - Parameter indexPath: Position of the tapped cell.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - FetchResultsController Delegate

extension GeneralViewController: NSFetchedResultsControllerDelegate {
    
    /**
     Indicates to the tableView that model updates are available.
     
     - Parameter controller: The fetched results controller that sent the message.
     */
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    /**
     Indicates to the tableView that model updates has ended.
     
     - Parameter controller: The fetched results controller that sent the message.
     */
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
        updateView()
    }
    
    /**
     Updates the tableView when the fetch controller changes.
     
     - Parameter controller: The fetched results controller that sent the message.
     - Parameter anObject: The object in controller’s fetched results that changed.
     - Parameter indexPath: The index path of the changed object.
     - Parameter type: The type of change.
     */
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        // Check CRUD operation
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                self.tableView.insertRows(at: [indexPath], with: .fade)
            }
            
        case .delete:
            if let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? GeneralTableViewCell {
                configure(cell, at: indexPath)
            }
            
        case .move:
            if let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                self.tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            
        @unknown default:
            break
        }
    }
    
}

// MARK: - Filter Delegate

extension GeneralViewController: FilterDelegate {
    
    /**
     Updates the displayed questions according to the selected filters.
     */
    func newFilters() {
        do {
            // Update fetched questions
            updatePredicate()
            try self.fetchedResultsController.performFetch()
            
            // Update tableView
            updateView()
            self.tableView.reloadData()
        } catch {
            showAlert(
                title: "No fue posible sincronizar tus categorías favoritas",
                message: "Inténtalo más tarde"
            )
        }
    }
    
    /**
     Updates the core data's predicates before perfoming a new fetch.
     */
    private func updatePredicate() {
        if let filters = self.currentUser.filtersAsArray {
            let categories: [String] = filters.compactMap { $0.category }
            self.fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "category IN %@", categories)
        }
    }
    
}

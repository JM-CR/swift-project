//
//  MyAnswersViewController.swift
//  you-say!
//
//  Created by Josue Mosiah Contreras Rocha on 10/29/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class MyAnswersViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textViewContent: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var labelCreatorName: UILabel!
    @IBOutlet weak var labelQuestionCategory: UITextField!
    @IBOutlet weak var labelQuestionContent: UILabel!
    @IBOutlet weak var labelQuestionCoordinate: UILabel!
    @IBOutlet weak var labelQuestionDate: UILabel!
    @IBOutlet weak var labelTotalLikes: UILabel!
    
    @IBOutlet weak var buttonLike: UIButton!
    @IBOutlet weak var activityIndicatorLocation: UIActivityIndicatorView!
    
    // MARK: Properties
    
    var answers: [Answer]? {
        return self.question?.answersByDate
    }
    
    var idFromAutor: UUID!
    var likeFromUser = false
    var dateFormatter: DateComponentsFormatter!
    
    // MARK: Core Data
    
    var question: Question!
    var currentUser: User!
    
    private var fetchedUser: User? {
        // Create request
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        // Configure request
        fetchRequest.predicate = NSPredicate(format: "id == %@", self.idFromAutor.uuidString)
        
        // Get results
        let fetchedResults = try? self.currentUser.managedObjectContext!.fetch(fetchRequest)
        return fetchedResults?.count == 0 ? nil : fetchedResults?.first
    }
    
    
    // MARK: - View Life Cycle
    
    /**
     Initial setup for the controller.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial setup
        setupViews()
        setupDelegates()
        setupGestures()
        setupNotifications()
    }
    
    /**
     Remove observers when it is disappearing.
     */
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Setup
    
    /**
     Initial set up for views.
     */
    private func setupViews() {
        // TextView
        self.textViewContent.text = "Comentar algo..."
        self.textViewContent.textColor = .lightGray
        
        // Stack View
        if let user = self.question.user {
            // Calculate location
            getAddress()
            
            // Fill information
            if let alias = user.alias {
                self.labelCreatorName.text = "\(user.name!) <\(alias)>"
            } else {
                self.labelCreatorName.text = user.name!
            }
            
            self.labelQuestionCategory.text = self.question.category
            self.labelQuestionContent.text = self.question.content
            self.labelTotalLikes.text = "\(self.question.likes)"
            
            // Like button image
            if self.question.likes > 0 {
                self.buttonLike.setImage(UIImage(named: "like"), for: .normal)
            } else {
                self.buttonLike.setImage(UIImage(named: "no-like"), for: .normal)
            }
            
            // Time from publish date
            let timeInterval = self.dateFormatter.string(from: self.question.createdAt!, to: Date())
            self.labelQuestionDate.text = "Hace \(timeInterval!)"
        }
    }
    
    /**
     Sets the delegates for the view controller.
     */
    private func setupDelegates() {
        self.textViewContent.delegate = self
    }
    
    /**
     Sets the initial gestures for the view controller.
     */
    private func setupGestures() {
        // Remove keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        self.view.addGestureRecognizer(tap)
    }
    
    /**
     Sets the observers for the view controller.
     */
    private func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        
        // Keyboard appearing
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        // Keyboard hiding
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        // Core Data
        notificationCenter.addObserver(
            self,
            selector: #selector(newAnswer),
            name: .NSManagedObjectContextObjectsDidChange,
            object: nil
        )
    }
    
    // MARK: Gestures
    
    /**
     Hides the keyboard when the user taps on the screen.
     */
    @objc func didTapView(){
        self.view.endEditing(true)
    }
    
    // MARK: Notifications
    
    /**
     Adjusts the content when the keyboard is appearing.
     
     - Parameter notification: Sent notification.
     */
    @objc func keyboardWillShow(notification: NSNotification) {
        // Get keyboard size
        let info = notification.userInfo!
        let keyboardFrame = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        // Update
        self.bottomConstraint.constant = 25 - keyboardFrame.size.height
        
        // Animate
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    /**
     Adjusts the content when the keyboard is hiding.
     
     - Parameter notification: Sent notification.
     */
    @objc func keyboardWillHide(notification: NSNotification) {
        // Update
        self.bottomConstraint.constant = 6
        
        // Animate
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    /**
     Updates the tableView with new information.
     
     - Parameter notification: Sent notification.
     */
    @objc func newAnswer(notification: NSNotification) {
        self.tableView.reloadData()
    }
    
    
    // MARK: - Processing
    
    /**
     Calculates the location name from a coordinate.
     */
    private func getAddress() {
        // Initial set
        var address = ""
        let location = CLLocation(latitude: self.question.latitude, longitude: self.question.longitude)
        let geoCoder = CLGeocoder()
        
        // Translate coordinate
        geoCoder.reverseGeocodeLocation(location) { (placeMarks, error) in
            // Place detail
            if let placeMark = placeMarks?[0] {
                self.activityIndicatorLocation.stopAnimating()
                address = "\(placeMark.subAdministrativeArea!), \(placeMark.administrativeArea!)"
                self.labelQuestionCoordinate.text = address
            }
        }
    }
    
    /**
     Creates a new answer.
     */
    private func createAnswer() throws {
        // Create
        let answer = Answer(context: self.currentUser.managedObjectContext!)
        
        // Set up
        answer.createdAt = Date()
        answer.content = self.textViewContent.text
        answer.from = self.currentUser.id
        
        // Link
        self.question.addToAnswers(answer)
        
        // Save
        try self.currentUser.managedObjectContext?.save()
        
        // Confirmation
        showAlert(title: "Publicada con éxito", message: "")
        
        // Clean up
        self.textViewContent.text = ""
    }
    
    
    // MARK: - Validation
    
    /**
     Validates the introduced answer by the user.
     */
    private func validateAnswer() throws {
        guard !self.textViewContent.text.isEmpty else {
            throw NewAnswerError.EmptyField(description: "No puedes dejar el campo vacío")
        }
    }
    
    
    // MARK: - Actions
    
    /**
     Returns to the generalVC.
     
     - Parameter sender: Button that triggered the action.
     */
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    /**
     Tries to create a new answer for the active question.
     */
    @IBAction func publishButtonPressed(_ sender: Any) {
        do {
            try validateAnswer()
            try createAnswer()
            
        } catch NewAnswerError.EmptyField(let description) {
            showAlert(title: "Respuesta inválida", message: description)
        } catch {
            showAlert(title: "No se pudo procesar", message: "Inténtalo más tarde")
        }
    }
    
    /**
     Add a new like to the question.
     */
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        // Update model
        if !self.likeFromUser {
            self.question.likes += 1
            self.likeFromUser = true
        } else {
            self.question.likes -= 1
            self.likeFromUser = false
        }
        
        self.labelTotalLikes.text = "\(self.question.likes)"
        
        // Update button
        self.buttonLike.isSelected = false
        if self.question.likes == 0 {
            self.buttonLike.setImage(UIImage(named: "no-like"), for: .normal)
        } else {
            self.buttonLike.setImage(UIImage(named: "like"), for: .normal)
        }
    }

}

// MARK: - TableView Data Source

extension MyAnswersViewController: UITableViewDataSource {
    
    /**
     Indicates the number of rows for a given section.
     
     - Parameter tableView: TableView object.
     - Parameter section: Section to query.
     - Returns: Total of rows for section.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let answers = self.answers {
            return answers.count
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
        let answerCell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath) as! AnswerTableViewCell
        
        // Get answer
        if let answer = self.answers?[indexPath.row] {
            // Time from publish date
            let timeInterval = self.dateFormatter.string(from: answer.createdAt!, to: Date())
            answerCell.labelDate.text = "Hace \(timeInterval!)"
            
            // Fill info
            self.idFromAutor = answer.from
            answerCell.labelAnswerContent.text = answer.content
            
            if let user = self.fetchedUser, let alias = user.alias {
                answerCell.labelAutor.text = "\(user.name!) <\(alias)>"
            } else {
                answerCell.labelAutor.text = self.fetchedUser?.name
            }
        }
        
        return answerCell
    }
    
}

// MARK: - TableView Delegate

extension MyAnswersViewController: UITableViewDelegate {
    
    /**
     Deselects a row when the user taps on it.
     
     - Parameter tableView: TableView object.
     - Parameter indexPath: Position of the tapped cell.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - TextView Delegate

extension MyAnswersViewController: UITextViewDelegate {
    
    /**
     Hides the keyboard when the user finishes editing.
     
     - Parameter textView: Object that triggered the event.
     - Returns: True to hide or false to keep.
     */
    func textViewShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    /**
     Clears the placeholder when the user is writing.
     
     - Parameter textView: Object that triggered the event.
     */
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    /**
     Adds the placeholder if the textView is empty.
     
     - Parameter textView: Object that triggered the event.
     */
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Comentar algo..."
            textView.textColor = .lightGray
        }
    }
    
}

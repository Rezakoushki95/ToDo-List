//
//  ToDoDetailTableViewController.swift
//  ToDo List
//
//  Created by Reza Koushki on 19/09/2022.
//

import UIKit

class ToDoDetailTableViewController: UITableViewController {

	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var nameField: UITextField!
	@IBOutlet weak var noteView: UITextView!
	@IBOutlet weak var saveBarButton: UIBarButtonItem!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
    }

	@IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
		let isPresentingInAddMode = presentingViewController is UINavigationController
		if isPresentingInAddMode {
			dismiss(animated: true, completion: nil)
		} else {
			navigationController?.popViewController(animated: true)
		}
	}
}

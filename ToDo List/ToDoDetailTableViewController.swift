//
//  ToDoDetailTableViewController.swift
//  ToDo List
//
//  Created by Reza Koushki on 19/09/2022.
//

import UIKit
import UserNotifications

private let dateFormatter: DateFormatter = {
	print("I JUST CREATED A DATEFORMATTER!")
	let dateFormatter = DateFormatter()
	dateFormatter.dateStyle = .short
	dateFormatter.timeStyle = .short
	return dateFormatter
}()

class ToDoDetailTableViewController: UITableViewController {
	
	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var nameField: UITextField!
	@IBOutlet weak var noteView: UITextView!
	@IBOutlet weak var reminderSwitch: UISwitch!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var saveBarButton: UIBarButtonItem!
	
	let datePickerIndexPath = IndexPath(row: 1, section: 1)
	let notesTextViewIndexPath = IndexPath(row: 0, section: 2)
	let notesRowHeight: CGFloat = 200
	let defaultRowHeight: CGFloat = 44
	
	var toDoItem: ToDoItem!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// setup foreground notifaction
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(appActiveNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
		
		let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
		tap.cancelsTouchesInView = false
		self.view.addGestureRecognizer(tap)
		
		nameField.delegate = self
		
		if toDoItem == nil {
			toDoItem = ToDoItem(name: "", date: Date().addingTimeInterval(24*60*60), notes: "", reminderSet: false, completed: false)
			nameField.becomeFirstResponder()
			saveBarButton.isEnabled = false
		}
		
		
		updateUI()
		
	}
	
	@objc func appActiveNotification() {
		print("The app just came to the foreground - cool!")
		updateReminderSwitch()
		
	}
	
	func updateUI() {
		nameField.text = toDoItem.name
		datePicker.date = toDoItem.date
		noteView.text = toDoItem.notes
		reminderSwitch.isOn = toDoItem.reminderSet
		dateLabel.textColor = (reminderSwitch.isOn ? .black : .gray)
		dateLabel.text = dateFormatter.string(from: toDoItem.date )
		enableDisableSaveButton(text: nameField.text!)
	}
	
	func updateReminderSwitch() {
		LocalNotificationManager.isAuthorized { (authorized) in
			DispatchQueue.main.async {
				if !authorized && self.reminderSwitch.isOn {
					self.oneButtonAlert(title: "User Has Not Allowed Notifcations", message: "To recive alerts for reminders, open the Settings app, select To Do List > Notifactions > Allow Notifications")
					self.reminderSwitch.isOn = false
				}
				self.view.endEditing(true)
				self.dateLabel.textColor = (self.reminderSwitch.isOn ? .black : .gray)
				self.tableView.beginUpdates()
				self.tableView.endUpdates()
			}
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		toDoItem = ToDoItem(name: nameField.text!, date: datePicker.date, notes: noteView.text, reminderSet: reminderSwitch.isOn, completed: toDoItem.completed)
	}
	
	func enableDisableSaveButton(text: String) {
		if text.count > 0 {
			saveBarButton.isEnabled = true
		} else {
			saveBarButton.isEnabled = false
		}
	}
	
	@IBAction func textFieldEditingChanged(_ sender: UITextField) {
		enableDisableSaveButton(text: sender.text!)
	}
	
	
	
	@IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
		let isPresentingInAddMode = presentingViewController is UINavigationController
		if isPresentingInAddMode {
			dismiss(animated: true, completion: nil)
		} else {
			navigationController?.popViewController(animated: true)
		}
	}
	
	@IBAction func reminderSwitchChanged(_ sender: UISwitch) {
		updateReminderSwitch()
		
	}
	@IBAction func datePickerChanged(_ sender: UIDatePicker) {
		self.view.endEditing(true)
		dateLabel.text = dateFormatter.string(from: sender.date)
	}
}

extension ToDoDetailTableViewController {
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath {
		case datePickerIndexPath:
			return reminderSwitch.isOn ? datePicker.frame.height : 0
		case notesTextViewIndexPath:
			return notesRowHeight
		default:
			return defaultRowHeight
			
		}
	}
	
}

extension ToDoDetailTableViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		noteView.becomeFirstResponder()
		return true
	}
}

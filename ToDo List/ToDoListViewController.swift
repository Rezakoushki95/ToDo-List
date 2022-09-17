//
//  ViewController.swift
//  ToDo List
//
//  Created by Reza Koushki on 15/09/2022.
//

import UIKit

class ToDoListViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	
	var toDoArray = ["Swift", "Build Apps", "Change the World", "Take a Vacation"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.dataSource = self
		tableView.delegate = self
	}

}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return toDoArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		cell.textLabel?.text = toDoArray[indexPath.row]
		return cell
	}
	
	
	
}


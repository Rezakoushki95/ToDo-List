//
//  ListTableViewCell.swift
//  ToDo List
//
//  Created by Reza Koushki on 09/10/2022.
//

import UIKit

protocol ListTableViewCellDelegate: class {
	
	func checkBoxToggle(sender: ListTableViewCell)
}

class ListTableViewCell: UITableViewCell {
	
	weak var delegate: ListTableViewCellDelegate?
	
	var toDoItem: ToDoItem! {
		didSet {
			nameLabel.text = toDoItem.name
			checkBoxButton.isSelected = toDoItem.completed
		}
	}

	@IBOutlet weak var checkBoxButton: UIButton!
	@IBOutlet weak var nameLabel: UILabel!
	
	@IBAction func checkToggled(_ sender: UIButton) {
		delegate?.checkBoxToggle(sender: self)
	}
	
	

}

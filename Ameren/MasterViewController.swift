//
//  MasterViewController.swift
//  Ameren
//
//  Created by David Giovannini on 8/8/16.
//  Copyright © 2016 Object Computing Inc. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
	var objects = [AnyObject]()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.leftBarButtonItem = self.editButtonItem
	}

	override func viewWillAppear(_ animated: Bool) {
		self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
		super.viewWillAppear(animated)
	}

	@IBAction func insertNewObject(_ sender: AnyObject) {
		objects.insert(NSDate(), at: 0)
		let indexPath = IndexPath(row: 0, section: 0)
		self.tableView.insertRows(at: [indexPath], with: .automatic)
	}
}

extension MasterViewController /*Segue*/ {
	// Called to setup a seque
	override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showDetail" {
		    if let indexPath = self.tableView.indexPathForSelectedRow {
		        let object = objects[indexPath.row] as! NSDate
				if let nav = segue.destination as? UINavigationController {
					let controller = nav.topViewController as! DetailViewController
					controller.detailItem = object
					controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
					controller.navigationItem.leftItemsSupplementBackButton = true
				}
		    }
		}
	}
	
	// This method is not necessary but allows you to introduce a command chain pattern into the hierarchy to flag
	// the destination of the unwind
	override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
		if self.responds(to: action) {
			return true
		}
		return false;
	}
	
	// The exit in IB wants an action. You can perform business logic here on the unwind.
	@IBAction func unwindDetail(unwindSegue: UIStoryboardSegue!) {
	}
}

extension MasterViewController /*TableView*/ {
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return objects.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		let object = objects[indexPath.row] as! NSDate
		cell.textLabel!.text = object.description
		return cell
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
		    objects.remove(at: indexPath.row)
		    tableView.deleteRows(at: [indexPath], with: .fade)
		} else if editingStyle == .insert {
		}
	}
}

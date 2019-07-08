//
//  MasterViewController.swift
//  Assignment Notebook
//
//  Created by Nicolas Yepes on 7/8/19.
//  Copyright © 2019 Nicolas Yepes. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var assignments = [Assignment]()
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        if let savedData = defaults.object(forKey: "data") as? Data {
            if let decoded = try? JSONDecoder().decode([Assignment].self, from: savedData) {
                assignments = decoded
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        tableView.reloadData()
        self.saveData()
    }

    @objc
    func insertNewObject(_ sender: Any) {
        let alert = UIAlertController (title: "Add Assignment", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Title"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Subject"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Due Date"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Description"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        let insertAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let titleTextField = alert.textFields![0] as UITextField
            let subjectTextField = alert.textFields![1] as UITextField
            let dueDateTextField = alert.textFields![2] as UITextField
            let descriptionTextField = alert.textFields![3] as UITextField
            let assignment = Assignment(title: titleTextField.text!, subject: subjectTextField.text!, dueDate: dueDateTextField.text!, description: descriptionTextField.text!)
            self.assignments.append(assignment)
            self.tableView.reloadData()
        }
        alert.addAction(insertAction)
        present(alert, animated: true, completion: nil)
        self.saveData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = assignments[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let object = assignments[indexPath.row]
        cell.textLabel!.text = object.title
        saveData()
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            assignments.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
        saveData()
    }
    
    func saveData() {
        if let encoded = try? JSONEncoder().encode(assignments) {
            defaults.set(encoded, forKey: "data")
        }
    }
}


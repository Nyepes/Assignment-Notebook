//
//  DetailViewController.swift
//  Assignment Notebook
//
//  Created by Nicolas Yepes on 7/8/19.
//  Copyright © 2019 Nicolas Yepes. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var describtionTextField: UITextField!
    var detailItem: Assignment? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let assignment = self.detailItem {
            if titleTextField != nil {
                titleTextField.text = assignment.title
                subjectTextField.text = assignment.subject
                dateTextField.text = assignment.dueDate
                describtionTextField.text = assignment.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let assignment = self.detailItem {
            assignment.title = titleTextField.text!
            assignment.subject = subjectTextField.text!
            assignment.dueDate = dateTextField.text!
            assignment.description = describtionTextField.text!
        }
    }
}


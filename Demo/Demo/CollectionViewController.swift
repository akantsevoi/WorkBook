//
//  CollectionViewController.swift
//  Demo
//
//  Created by Aliaksandr Kantsevoi on 12/29/17.
//  Copyright © 2017 Aliaksandr Kantsevoi. All rights reserved.
//

import UIKit
import WorkBook

class CollectionViewController: UIViewController, UITableViewDataSource {
    
    var binder: WorkbookBinder<[String]>! = nil
    @IBOutlet weak var tableView: UITableView!
    var models: [String] = [] {
        didSet {
            tableView.reloadSections(IndexSet(integer: 0), with: UITableViewRowAnimation.none)
        }
    }
    
    var timer: DispatchSourceTimer?

    override func viewDidLoad() {
        super.viewDidLoad()

        binder = WorkbookBinder<[String]>(value: self.models, resourceKey: "names")
        binder.subscribe { [weak self] (newNames) in
            DispatchQueue.main.async {
                self?.models = newNames
            }
        }
    }

    @IBAction func deleteLatest(_ sender: Any) {
        if models.count > 0 {
            models.removeLast()
            binder.update(value: models)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("new number of Rows: \(models.count)")
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "modelCell", for: indexPath)
        
        cell.textLabel?.text = models[indexPath.row]
        print("new cell data: \(models[indexPath.row])")
        
        return cell
    }

}


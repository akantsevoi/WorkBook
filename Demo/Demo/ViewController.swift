//
//  CollectionViewController.swift
//  Demo
//
//  Created by Aliaksandr Kantsevoi on 12/29/17.
//  Copyright © 2017 Aliaksandr Kantsevoi. All rights reserved.
//

import UIKit
import WorkBook

class CollectionViewController: UIViewController {
    
    var binder: WorkbookBinder<[String]>! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        binder = WorkbookBinder<[String]>(value: [], resourceKey: "names")
        binder.subscribe { (newNames) in
            print(newNames)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


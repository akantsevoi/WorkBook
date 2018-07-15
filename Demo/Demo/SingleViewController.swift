//
//  SingleViewController.swift
//  Demo
//
//  Created by Aliaksandr Kantsevoi on 12/31/17.
//  Copyright © 2017 Aliaksandr Kantsevoi. All rights reserved.
//

import UIKit
import WorkBook

struct TrackModel: Codable {
    var name: String
    var author: String
    var duration: Int
    var purchased: Bool
}

class SingleViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    
    var binder: WorkbookBinder<TrackModel>! = nil
    
    var trackModel: TrackModel = TrackModel(name: "Numb", author: "Linkin park", duration: 230, purchased: true) {
        didSet {
            updateModel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        binder = WorkbookBinder<TrackModel>(value: self.trackModel, resourceKey: "audioTrack")
        binder.subscribe { [weak self] (newModel) in
            DispatchQueue.main.async {
                self?.trackModel = newModel
            }
        }
    }
    
    private func updateModel() {
        nameLabel.text = trackModel.name
        authorLabel.text = trackModel.author
        durationLabel.text = "\(trackModel.duration)s"
        stateLabel.text = trackModel.purchased ? "Purchased" : "Available for purchase"
    }
}

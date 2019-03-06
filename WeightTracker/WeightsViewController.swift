//
//  ViewController.swift
//  WeightTracker
//
//  Created by Paul Zabelin on 3/3/19.
//  Copyright © 2019 Paul Zabelin. All rights reserved.
//

import UIKit
import CoreData

class WeightsViewController: UIViewController {
    var fetchController: NSFetchedResultsController<WeightEntry>! {
        didSet {
            fetchController.fetchRequest.fetchBatchSize = 10
            fetchController.fetchRequest.fetchOffset = 30
            fetchController.fetchRequest.fetchLimit = 20
            try? fetchController.performFetch()
        }
    }
    var generator: RandomGenerator!
    var dateFormatter: DateFormatter!
    @IBOutlet weak var tableView: UITableView!

    var context: NSManagedObjectContext {
        return fetchController.managedObjectContext
    }

    @IBAction func addWeight(_ sender: UIBarButtonItem) {
        context.insert(Init(value: WeightEntry(context: context)) {
            $0.date = Date()
            $0.weight = generator.randomWeight()
        })
        saveAndReload()
    }

    func saveAndReload() {
        try? context.save()
        try? fetchController.performFetch()
        tableView.reloadData()
    }
}

extension WeightsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchController.sections![section].numberOfObjects
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return Init(value: tableView.dequeueReusableCell(withIdentifier: "weight cell")!) {
            let weightEntry = fetchController.object(at: indexPath)
            $0.textLabel!.text = String(format: "%3.01f", weightEntry.weight)
            $0.detailTextLabel!.text = dateFormatter.string(from: weightEntry.date!)
        }
    }
}

extension WeightsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        context.delete(fetchController.object(at: indexPath))
        saveAndReload()
    }
}

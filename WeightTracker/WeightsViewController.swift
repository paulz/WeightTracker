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
        let entry = WeightEntry(context: fetchController.managedObjectContext)
        entry.date = Date()
        entry.weight = generator.randomWeight()
        context.insert(entry)
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
        return fetchController.fetchedObjects!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weight cell")!
        let weightEntry = fetchController.object(at: indexPath)
        cell.textLabel?.text = String(format: "%3.01f", weightEntry.weight)
        cell.detailTextLabel?.text = dateFormatter.string(from: weightEntry.date!)
        return cell
    }
}

extension WeightsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        context.delete(fetchController.object(at: indexPath))
        saveAndReload()
    }
}

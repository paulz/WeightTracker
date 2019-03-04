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
    var context: NSManagedObjectContext!
    var fetchController: NSFetchedResultsController<WeightEntry>!
    var generator: RandomGenerator!
    @IBOutlet weak var tableView: UITableView!

    @IBAction func addWeight(_ sender: UIBarButtonItem) {
        let entry = WeightEntry(context: context)
        entry.date = Date()
        entry.weight = generator.randomWeight()
        context.insert(entry)
        try? context.save()
        try? fetchController.performFetch()
        tableView.reloadData()
    }

    func fetchData() {
        let fetchRequest: NSFetchRequest<WeightEntry> = WeightEntry.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \WeightEntry.date, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                     managedObjectContext: context,
                                                     sectionNameKeyPath: nil,
                                                     cacheName: nil)
        try? fetchController.performFetch()
    }
}

extension WeightsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchController.fetchedObjects!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weight cell")!
        let weightEntry = fetchController.object(at: indexPath)
        cell.textLabel?.text = weightEntry.weight.description
        cell.detailTextLabel?.text = weightEntry.date?.description
        return cell
    }
}

extension WeightsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let weightEntry = fetchController.object(at: indexPath)
        context.delete(weightEntry)
        try? fetchController.performFetch()
        tableView.reloadData()
    }
}

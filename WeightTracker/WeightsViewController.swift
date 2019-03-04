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
    @IBOutlet weak var tableView: UITableView!

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

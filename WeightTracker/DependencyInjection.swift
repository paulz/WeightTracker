import SwinjectStoryboard
import SwinjectAutoregistration
import CoreData
import GameKit

extension SwinjectStoryboard {
    public static func setup() {
        defaultContainer.register(NSPersistentContainer.self) { _ in
            loadAppData()
            let container = NSPersistentContainer(name: "WeightTracker")
            container.loadPersistentStores { (description: NSPersistentStoreDescription, error: Error?) in
                assert(error == nil)
                assert(description.shouldInferMappingModelAutomatically)
                assert(description.shouldMigrateStoreAutomatically)
                assert(!description.shouldAddStoreAsynchronously)
                assert(!description.isReadOnly)
                NSLog("persistent store path: \(description.url!.path)")
            }
            return container
        }.inObjectScope(.container)
        defaultContainer.register(NSManagedObjectContext.self) { r in
            return (r~>NSPersistentContainer.self).viewContext
        }
        defaultContainer.register(NSFetchRequest<WeightEntry>.self) { _ in
            WeightEntry.fetchRequest()
        }
        defaultContainer.register(NSFetchedResultsController<WeightEntry>.self) { r in
            let fetchRequest: NSFetchRequest<WeightEntry> = r~>
            fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \WeightEntry.date, ascending: false)]
            return NSFetchedResultsController(fetchRequest: fetchRequest,
                                              managedObjectContext: r~>,
                                              sectionNameKeyPath: nil,
                                              cacheName: nil)
        }
        defaultContainer.register(RandomGenerator.self) { r in
            let generator = RandomGenerator()
            generator.randomSource = r~>
            return generator
        }
        defaultContainer.register(GKRandomSource.self) { _ in
            GKLinearCongruentialRandomSource(seed: 42)
        }
        defaultContainer.register(DateFormatter.self) { _ in
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter
        }
        defaultContainer.storyboardInitCompleted(UINavigationController.self) { _, _ in }
        defaultContainer.storyboardInitCompleted(WeightsViewController.self) { r, c in
            c.fetchController = r~>
            c.generator = r~>
            c.dateFormatter = r~>
        }
    }
}

import SwinjectStoryboard
import SwinjectAutoregistration
import CoreData
import GameKit

extension SwinjectStoryboard {
    public static func setup() {
        loadAppData()
        defaultContainer.autoregister(NSPersistentContainer.self) {
            Init(value: NSPersistentContainer(name: "WeightTracker")) {
                $0.loadPersistentStores { description, error in
                    assert(error == nil)
                    assert(description.shouldInferMappingModelAutomatically)
                    assert(description.shouldMigrateStoreAutomatically)
                    assert(!description.shouldAddStoreAsynchronously)
                    assert(!description.isReadOnly)
                    NSLog("persistent store path: \(description.url!.path)")
                }
            }
        }.inObjectScope(.container)
        defaultContainer.register(NSManagedObjectContext.self) {
            ($0~>NSPersistentContainer.self).viewContext
        }
        defaultContainer.autoregister(NSFetchRequest<WeightEntry>.self) {
            Init(value: WeightEntry.fetchRequest()) {
                $0.sortDescriptors = [NSSortDescriptor(keyPath: \WeightEntry.date,
                                                       ascending: false)]
            }
        }
        defaultContainer.autoregister(
            NSFetchedResultsController<NSFetchRequestResult>.self,
            initializer:
            NSFetchedResultsController<NSFetchRequestResult>
                .init(fetchRequest:managedObjectContext:sectionNameKeyPath:cacheName:)
        )
        defaultContainer.autoregister(RandomGenerator.self, initializer:RandomGenerator.init(source:))
        defaultContainer.autoregister(GKRandomSource.self) {
            GKLinearCongruentialRandomSource(seed: 42)
        }
        defaultContainer.autoregister(DateFormatter.self) {
            Init(value: DateFormatter()) {$0.dateStyle = .medium}
        }
        defaultContainer.storyboardInitCompleted(UINavigationController.self) { _, _ in }
        defaultContainer.storyboardInitCompleted(WeightsViewController.self) { r, c in
            c.fetchController = r~>
            c.generator = r~>
            c.dateFormatter = r~>
        }
    }
}

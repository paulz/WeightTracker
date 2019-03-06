import Quick
import Nimble
import CoreData
import SwinjectStoryboard
@testable import WeightTracker

class DataModelSpec: QuickSpec {
    override func spec() {
        describe("Core Data Model") {
            let container = SwinjectStoryboard.defaultContainer
            var moc: NSManagedObjectContext!

            beforeEach {
                moc = container.resolve(NSManagedObjectContext.self)
            }

            afterEach {
                moc.rollback()
            }

            context("Entities") {
                it("should have weight entry") {
                    let names = moc.persistentStoreCoordinator?.managedObjectModel.entitiesByName.keys.map {$0}
                    expect(names).to(contain(["WeightEntry"]))
                }
            }
            context("WeightEntry") {
                var entry: WeightEntry!

                beforeEach {
                    entry = WeightEntry(context: moc)
                }

                context("email") {
                    it("should allow valid weight") {
                        entry.weight = 139.0
                        entry.date = Date()
                        try! moc.save()
                        expect(entry.weight) == 139.0
                        expect(moc.hasChanges) == false
                    }

                    it("should raise validation errors when there are missing fields") {
                        let expected = CocoaError.error(.validationMissingMandatoryProperty) as NSError
                        entry.weight = 130.0
                        expect {
                                try entry.managedObjectContext?.save()
                            }.to(throwError { (error: NSError) in
                                expect(error.domain) == expected.domain
                                expect(error.code) == expected.code
                            })
                    }
                }

                context("fetchRequest") {
                    fit("should load all entries") {
//                        let request: NSFetchRequest<WeightEntry> = WeightEntry.fetchRequest()
//                        let entries = try! moc.fetch(request)
//                        expect(entries.count) >= 1

                        let another = NSFetchRequest<NSDictionary>()
                        another.entity = WeightEntry.entity()
                        another.resultType = .dictionaryResultType
                        let desc = NSExpressionDescription()
                        desc.name = "average"
                        desc.expression = NSExpression(forKeyPath: "@avg.weight")
                        desc.expressionResultType = .doubleAttributeType
                        another.propertiesToFetch = [desc]
                        let result = try! moc.fetch(another)
                        print(result.first)
                    }
                }
            }
        }
    }
}

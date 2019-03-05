import Quick
import Nimble

class WeightListSpec: QuickSpec {
    override func spec() {
        let app = XCUIApplication()
        let tables = app.tables

        describe("list of weights view") {
            context("existing") {
                it("should show previous entries") {
                    expect(tables.staticTexts["150.0"].waitForExistence()) == true
                }
            }

            context("add entry") {
                var formatter: DateFormatter!

                beforeEach {
                    formatter = DateFormatter()
                    formatter.dateStyle = .medium
                }

                it("should show new weight with today's date") {
                    app.buttons["Add"].tap()
                    expect(tables.staticTexts["120.2"].waitForExistence()) == true
                    let today = formatter.string(from: Date())
                    expect(tables.staticTexts[today].exists) == true
                }
            }

            context("delete entry") {
                it("should remove it from the list") {
                    let cell = tables.cells
                        .containing(.staticText, identifier: "151.0").element

                    cell.swipeLeft()
                    cell.buttons["Delete"].tap()
                    expect(tables.cells.staticTexts["151.0"].exists).toEventually(beFalse())
                }
            }
        }
    }
}

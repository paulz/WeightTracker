import Quick
import Nimble

class WeightListSpec: QuickSpec {
    override func spec() {
        let app = XCUIApplication()
        let tables = app.tables

        describe("list of weights view") {
            context("1 existing") {
                it("should show previous entries in reverse chronological order") {
                    expect(tables.staticTexts["150.0"].waitForExistence()) == true
                    expect(tables.cells.element(boundBy: 0).staticTexts["Mar 1, 2019"].exists) == true
                    expect(tables.cells.element(boundBy: 1).staticTexts["Feb 28, 2019"].exists) == true
                }
            }

            context("today's entry") {
                var today: String!

                beforeEach {
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    today = formatter.string(from: Date())
                }

                context("1 add entry") {
                    it("should show new weight with today's date") {
                        app.buttons["Add"].tap()
                        expect(tables.staticTexts["120.2"].waitForExistence()) == true
                        expect(tables.staticTexts[today].exists) == true
                    }
                }

                context("2 delete entry") {
                    it("should remove it from the list") {
                        let cell = tables.cells
                            .containing(.staticText, identifier: today).element

                        cell.swipeLeft()
                        cell.buttons["Delete"].tap()
                        expect(tables.cells.staticTexts[today].exists).toEventually(beFalse())
                    }
                }
            }
        }
    }
}

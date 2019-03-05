import Quick
import Nimble

class WeightListSpec: QuickSpec {
    override func spec() {
        let app = XCUIApplication()
        let tables = app.tables
        let cells = tables.cells

        describe("list of weights view") {
            context("existing") {
                it("should show previous entries in reverse chronological order") {
                    expect(app.navigationBars["Weight Tracker"].waitForExistence()) == true
                    expect(cells.staticTexts["150.0"].waitForExistence()) == true
                    expect(cells.element(boundBy: 0).staticTexts["Mar 1, 2019"].exists) == true
                    expect(cells.element(boundBy: 1).staticTexts["Feb 28, 2019"].exists) == true
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
                        app.navigationBars.buttons["Add"].tap()
                        expect(cells.staticTexts["120.2"].waitForExistence()) == true
                        expect(cells.staticTexts[today].exists) == true
                    }
                }

                context("2 persists after restart") {
                    beforeEach {
                        app.terminate()
                        app.launchEnvironment = [:]
                        app.launch()
                        app.activate()
                    }

                    context("delete entry") {
                        it("should remove it from the list") {
                            let cell = cells
                                .containing(.staticText, identifier: today).element

                            cell.swipeLeft()
                            cell.buttons["Delete"].tap()
                            expect(cell.exists).toEventually(beFalse())
                        }
                    }
                }
            }
        }
    }
}

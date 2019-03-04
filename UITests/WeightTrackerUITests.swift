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
        }
    }
}

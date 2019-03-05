import Quick
import XCTest
import Nimble

class AppConfiguration: QuickConfiguration {
    override class func configure(_ configuration: Configuration) {
        AsyncDefaults.Timeout = 5
        AsyncDefaults.PollInterval = 0.2

        func launchApp() {
            let app = XCUIApplication()
            app.launchEnvironment["LOAD_APPDATA"] = "../UITests/SampleData"
            app.launch()
            assert(app.wait(for: .runningForeground, timeout: 10))
            app.activate()
        }

        configuration.beforeSuite {
            launchApp()
        }
    }
}

extension XCUIElement {
    func waitForExistence() -> Bool {
        return waitForExistence(timeout: AsyncDefaults.Timeout)
    }
}

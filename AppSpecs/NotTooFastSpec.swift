import Quick
import Nimble

/// To avoid crashes in xcodebuild reporter: https://github.com/Microsoft/azure-pipelines-tasks/issues/8840
class NotTooFastSpec: QuickSpec {
    override func spec() {
        describe("slow running spec") {
            context("on travis") {
                it("should run for 1 second") {
                    let start = Date()
                    RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
                    let finish = Date()
                    expect(finish.timeIntervalSince(start)) >= 1.0
                }
            }
        }
    }
}

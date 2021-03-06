import Quick
import Nimble

extension Array where Element: Strideable {
    func biggestLoss() -> Element.Stride? {
        let maximums = indices.map {prefix(through: $0).max()!}
        let minimums = indices.map {suffix(from: $0).min()!}
        return indices.map {minimums[$0].distance(to: maximums[$0])}.max()
    }
}

class BiggestLossSpec: QuickSpec {
    override func spec() {
        describe("biggestLoss") {
            it("should be 2 for 3,2,1") {
                expect([3, 2, 1].biggestLoss()) == 2
            }
            it("should be 0 for 1,2,3") {
                expect([1, 2, 3].biggestLoss()) == 0
            }
            it("should be 1 for 3,2,2") {
                expect([3, 2, 2].biggestLoss()) == 1
            }
            it("should be 1 for 3,3,2") {
                expect([3, 3, 2].biggestLoss()) == 1
            }
            it("should be 2 for 3,1,4,3,3") {
                expect([3, 1, 4, 3, 3].biggestLoss()) == 2
            }
            it("should be 2 for 3,2,2,3,1,1,2,3") {
                expect([3, 2, 2, 3, 1, 1, 2, 3].biggestLoss()) == 2
            }
            it("should be nil when empty") {
                expect([Float]().biggestLoss()).to(beNil())
            }

            context("floats") {
                it("should be a float") {
                    expect([3.1, 2, 0.9].biggestLoss()) == 2.2
                }
            }
        }
    }
}

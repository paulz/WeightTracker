import Quick
import Nimble

func biggestWeighLost(weights: [Float]) -> Float? {
    let maximums = maximumFirstWeight(weights: weights)
    let minimums = minimumLastWeight(weights: weights)
    return weights.indices.map {maximums[$0] - minimums[$0]}.max()
}

func maximumFirstWeight(weights: [Float]) -> [Float] {
    return weights.indices.map {weights[0...$0].max()!}
}

func minimumLastWeight(weights: [Float]) -> [Float] {
    return weights.indices.map {weights[$0...].min()!}
}

class BiggestWeightLossSpec: QuickSpec {
    override func spec() {
        fdescribe("biggestWeighLost") {
            it("should be 2 for 3,2,1") {
                expect(biggestWeighLost(weights: [3, 2, 1])) == 2
            }
            it("should be 0 for 1,2,3") {
                expect(biggestWeighLost(weights: [1, 2, 3])) == 0
            }
            it("should be 1 for 3,2,2") {
                expect(biggestWeighLost(weights: [3, 2, 2])) == 1
            }
            it("should be 1 for 3,3,2") {
                expect(biggestWeighLost(weights: [3, 3, 2])) == 1
            }
            it("should be 2 for 3,1,4,3,3") {
                expect(biggestWeighLost(weights: [3, 1, 4, 3, 3])) == 2
            }
            it("should be 2 for 3,2,2,3,1,1,2,3") {
                expect(biggestWeighLost(weights: [3, 2, 2, 3, 1, 1, 2, 3])) == 2
            }
            it("should be nil when empty") {
                expect(biggestWeighLost(weights: [])).to(beNil())
            }
        }
    }
}

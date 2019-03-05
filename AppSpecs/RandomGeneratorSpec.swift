import Quick
import Nimble
import GameKit
@testable import WeightTracker

class MockSourceUpperBound: GKRandomSource {
    override func nextInt(upperBound: Int) -> Int {
        return upperBound
    }
}

class MockSourceLowerBound: GKRandomSource {
    override func nextInt(upperBound: Int) -> Int {
        return 0
    }
}

class RandomGeneratorSpec: QuickSpec {
    override func spec() {
        describe("RandomGenerator") {
            var generator: RandomGenerator!

            beforeEach {
                generator = RandomGenerator()
            }

            context("randomWeight") {
                it("should produce values between 120 and 170") {
                    generator.randomSource = MockSourceUpperBound()
                    expect(generator.randomWeight()) ≈ 170
                    generator.randomSource = MockSourceLowerBound()
                    expect(generator.randomWeight()) ≈ 120
                }
            }
        }
    }
}

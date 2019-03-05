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

            context("randomWeight") {
                context("upper bound") {
                    beforeEach {
                        generator = RandomGenerator(source: MockSourceUpperBound())
                    }

                    it("should produce values up to 170") {
                        expect(generator.randomWeight()) ≈ 170
                    }
                }

                context("lower bound") {
                    beforeEach {
                        generator = RandomGenerator(source: MockSourceLowerBound())
                    }

                    it("should produce values 120 and above") {
                        expect(generator.randomWeight()) ≈ 120
                    }
                }
            }
        }
    }
}

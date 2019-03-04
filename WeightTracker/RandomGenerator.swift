//
//  RandomGenerator.swift
//  WeightTracker
//
//  Created by Paul Zabelin on 3/4/19.
//  Copyright © 2019 Paul Zabelin. All rights reserved.
//

import Foundation
import GameKit

class RandomGenerator {
    var randomSource: GKRandomSource!

    func randomWeight() -> Float {
        let lowerLimit: Float = 120
        let upperLimit: Float = 170
        return lowerLimit + (upperLimit - lowerLimit) * randomSource.nextUniform()
    }
}

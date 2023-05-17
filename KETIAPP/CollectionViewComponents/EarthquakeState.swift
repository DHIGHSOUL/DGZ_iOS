//
//  NormalState.swift
//  KETIAPP
//
//  Created by ROLF J. on 2023/05/12.
//

import Foundation

struct EarthquakeState {
    let magnitude: String
    let magnitudeValue: Float
    let intensity: String
    let intensityValue: String
}

extension EarthquakeState {
    static let normalState = EarthquakeState(magnitude: "규모", magnitudeValue: 0.0, intensity: "진도", intensityValue: "-")
}

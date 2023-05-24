//
//  Detect.swift
//  KETIAPP
//
//  Created by ROLF J. on 2023/05/12.
//

import Foundation

struct Location: Codable {
    let lat: String
    let lng: String
}

class Detect {
//  Singletone
    private static let detect = Detect()
    public static func sharedDetect() -> Detect {
        return detect
    }
    
//  Check earthquake status
    func checkEarthquakeStatus() {
        
    }
    
//  TODO: Make getMagnitude method -
//  Get magnitude of earthquake
    func getMagnitude(magnitude: Float) -> String {
        return String(magnitude)
    }
    
//  Make intensity string for intensityValue
    func intensityValue(intensity: Float) -> String {
        let value = Int(intensity)
        var intensityString = ""
        
        switch value {
        case 1:
            intensityString = "I"
        case 2:
            intensityString = "II"
        case 3:
            intensityString = "III"
        case 4:
            intensityString = "IV"
        case 5:
            intensityString = "V"
        case 6:
            intensityString = "VI"
        case 7:
            intensityString = "VII"
        case 8:
            intensityString = "VIII"
        case 9:
            intensityString = "IX"
        case 10:
            intensityString = "X"
        default:
            intensityString = "I"
        }
        
        return intensityString
    }
}

//
//  Detect.swift
//  KETIAPP
//
//  Created by ROLF J. on 2023/05/12.
//

import UIKit

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
    
//  Set intensity string and color for intensityValue
    func setIntensityView(intensity: Float) -> (String, UIColor) {
        let value = Int(intensity)
        var intensityString = ""
        var intensityColor: UIColor!
        
        switch value {
        case 1:
            intensityString = "I"
            intensityColor = .clear
        case 2:
            intensityString = "II"
            intensityColor = .systemCyan.withAlphaComponent(0.2)
        case 3:
            intensityString = "III"
            intensityColor = .systemGreen.withAlphaComponent(0.3)
        case 4:
            intensityString = "IV"
            intensityColor = .systemYellow.withAlphaComponent(0.4)
        case 5:
            intensityString = "V"
            intensityColor = .systemOrange.withAlphaComponent(0.5)
        case 6:
            intensityString = "VI"
            intensityColor = .systemRed.withAlphaComponent(0.6)
        case 7:
            intensityString = "VII"
            intensityColor = .systemPurple.withAlphaComponent(0.7)
        case 8:
            intensityString = "VIII"
            intensityColor = UIColor(red: 255*0.36, green: 255*0.16, blue: 255*0.15, alpha: 0.8)
        case 9:
            intensityString = "IX"
            intensityColor = .systemBrown.withAlphaComponent(0.9)
        case 10:
            intensityString = "X"
            intensityColor = .black.withAlphaComponent(1)
        case 11:
            intensityString = "XI"
            intensityColor = .black.withAlphaComponent(1)
        case 12:
            intensityString = "XII"
            intensityColor = .black.withAlphaComponent(1)
        default:
            intensityString = "I"
            intensityColor = .clear
        }
        
        return (intensityString, intensityColor)
    }
    
//  Set magnitude string and color for magnitudeValue
    func setMagnitudeView(magnitude: Float) -> (String, UIColor) {
        var magnitudeString = String(format: "%.1f", magnitude)
        
        let value = Int(magnitude)
        var magnitudeColor: UIColor!
        
        switch value {
        case 1:
            magnitudeColor = UIColor(red: 255*0.6, green: 255*0.84, blue: 255*0.56, alpha: 0.2)
        case 2:
            magnitudeColor = UIColor(red: 255*0.38, green: 255*0.73, blue: 255*0.29, alpha: 0.3)
        case 3:
            magnitudeColor = .systemYellow.withAlphaComponent(0.4)
        case 4:
            magnitudeColor = .systemOrange.withAlphaComponent(0.5)
        case 5:
            magnitudeColor = .systemPink.withAlphaComponent(0.6)
        case 6:
            magnitudeColor = UIColor(red: 255*0.92, green: 255*0.4, blue: 255*0.38, alpha: 0.7)
        case 7:
            magnitudeColor = .systemRed.withAlphaComponent(0.8)
        case 8:
            magnitudeColor = UIColor(red: 255*0.82, green: 255*0.17, blue: 255*0.12, alpha: 0.9)
        case 9, 10:
            magnitudeColor = UIColor(red: 255*0.73, green: 255*0.15, blue: 255*0.1, alpha: 1)
        default:
            magnitudeString = "-"
            magnitudeColor = .clear
        }
        
        return (magnitudeString, magnitudeColor)
    }
}

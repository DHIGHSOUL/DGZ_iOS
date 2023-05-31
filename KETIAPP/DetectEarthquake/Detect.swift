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
    
    // GET magnitude and maximum intensity
    func getMaxMagAndInt(completion: @escaping([String]) -> ()) {
        var request = URLRequest(url: URL(string: "http://203.253.128.177:7579/Mobius/KETIDGZ_earthquake/web_scrapping/latest")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("12345", forHTTPHeaderField: "X-M2M-RI")
        request.addValue("SOrigin", forHTTPHeaderField: "X-M2M-Origin")
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("Cannot GET data")
                return
            }
            
            let successRange = 200..<300
            print("")
            print("====================================")
            print("[requestGET : http get 요청 성공]")
            print("Response : ", (response as? HTTPURLResponse)?.statusCode ?? 0)
            print("====================================")
            print("")
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode) else {
                print("")
                print("====================================")
                print("[requestGET : http get 요청 에러]")
                print("Error : ", (response as? HTTPURLResponse)?.statusCode ?? 0)
                print("====================================")
                print("")
                return
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                let jsonObject = jsonData?["m2m:cin"] as? [String:Any]
                let con = jsonObject?["con"] as? String
                let earthquakeInformation: String = con ?? "N/A"
                let informationArray: [String] = earthquakeInformation.split(separator: "@").map { String($0) }
                print("informationArray: \(informationArray)")
                completion(informationArray)
            } catch {
                print("JSON Error occured")
            }
        }
        task.resume()
    }
    
//  TODO: Make getMagnitude method -
//  Get magnitude of earthquake
    func getMagnitude(magnitude: Float) -> String {
        return String(magnitude)
    }
    
//  Set intensity string and color for intensityValue
    func setIntensityView(intensity: String) -> (String, UIColor) {
        var intensityColor: UIColor!
        
        switch intensity {
        case "I":
            intensityColor = .clear
        case "II":
            intensityColor = .systemCyan.withAlphaComponent(0.2)
        case "III":
            intensityColor = .systemGreen.withAlphaComponent(0.3)
        case "IV":
            intensityColor = .systemYellow.withAlphaComponent(0.4) 
        case "V":
            intensityColor = .systemOrange.withAlphaComponent(0.5)
        case "VI":
            intensityColor = .systemRed.withAlphaComponent(0.6)
        case "VII":
            intensityColor = .systemPurple.withAlphaComponent(0.7)
        case "VIII":
            intensityColor = UIColor(red: 0.36, green: 0.16, blue: 0.15, alpha: 0.8)
        case "IX":
            intensityColor = .systemBrown.withAlphaComponent(0.9)
        case "X":
            intensityColor = .black.withAlphaComponent(1)
        case "XI":
            intensityColor = .black.withAlphaComponent(1)
        case "XII":
            intensityColor = .black.withAlphaComponent(1)
        default:
            intensityColor = .clear
        }
        
        return (intensity, intensityColor)
    }
    
//  Set magnitude string and color for magnitudeValue
    func setMagnitudeView(magnitude: Float) -> (String, UIColor) {
        var magnitudeString = String(format: "%.1f", magnitude)
        
        let value = Int(magnitude)
        var magnitudeColor: UIColor!
        
        switch value {
        case 1:
            magnitudeColor = UIColor(red: 0.6, green: 0.84, blue: 0.56, alpha: 0.2)
        case 2:
            magnitudeColor = UIColor(red: 0.38, green: 0.73, blue: 0.29, alpha: 0.3)
        case 3:
            magnitudeColor = .systemYellow.withAlphaComponent(0.4)
        case 4:
            magnitudeColor = .systemOrange.withAlphaComponent(0.5)
        case 5:
            magnitudeColor = .systemPink.withAlphaComponent(0.6)
        case 6:
            magnitudeColor = UIColor(red: 0.92, green: 0.4, blue: 0.38, alpha: 0.7)
        case 7:
            magnitudeColor = .systemRed.withAlphaComponent(0.8)
        case 8:
            magnitudeColor = UIColor(red: 0.82, green: 0.17, blue: 0.12, alpha: 0.9)
        case 9, 10:
            magnitudeColor = UIColor(red: 0.73, green: 0.15, blue: 0.1, alpha: 1)
        default:
            magnitudeString = "-"
            magnitudeColor = .clear
        }
        
        return (magnitudeString, magnitudeColor)
    }
}

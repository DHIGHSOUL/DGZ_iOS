//
//  SensorTimer.swift
//  KETIAPP
//
//  Created by ROLF J. on 2023/05/24.
//

import Foundation

class MyTimer {
    var timer: Timer?
    
    // ViewController control closure
    var controlClosure: ((EarthquakeState) -> Void)?
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(getSenserData), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func getSenserData() {
        var request = URLRequest(url: URL(string: "http://203.253.128.177:7579/Mobius/KETIDGZ/earthquake/latest")!,timeoutInterval: Double.infinity)
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
            print("[requestPOST : http post 요청 성공]")
            print("Response : ", (response as? HTTPURLResponse)?.statusCode ?? 0)
            print("====================================")
            print("")
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode) else {
                print("")
                print("====================================")
                print("[requestPOST : http post 요청 에러]")
                print("Error : ", (response as? HTTPURLResponse)?.statusCode ?? 0)
                print("====================================")
                print("")
                return
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                let jsonObject = jsonData?["m2m:cin"] as? [String:Any]
                let con = jsonObject?["con"] as? String
                let earthquakeDetect: String = con ?? "N/A"
                if earthquakeDetect == "1" {
                    print("Earthquake occured, change .whileEarthquake")
                    self.controlClosure?(.whileEarthquake)
                    self.stopTimer()
                }
                print(earthquakeDetect)
            } catch {
                print("JSON Error occured")
            }
        }
        task.resume()
    }
}

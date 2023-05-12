//
//  Detect.swift
//  KETIAPP
//
//  Created by ROLF J. on 2023/05/12.
//

import Foundation

class Detect {
//  Singletone
    private static let detect = Detect()
    public static func sharedDetect() -> Detect {
        return detect
    }
    
//  Check earthquake status
    func checkEarthquakeStatus() {
//        KETIViewController().earthQuake.toggle()
    }
}

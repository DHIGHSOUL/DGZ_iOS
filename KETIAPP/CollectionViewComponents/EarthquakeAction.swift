//
//  EarthquakeAction.swift
//  KETIAPP
//
//  Created by ROLF J. on 2023/05/30.
//

import Foundation

public struct EarthquakeAction {
    let imageName: String
    let description: String
}

extension EarthquakeAction {
    static let normalActionArray: [EarthquakeAction] = [
        EarthquakeAction(imageName: "NormalAction1", description: "위급상황을 대비하여 구급상자 등을 구비해주세요"),
        EarthquakeAction(imageName: "NormalAction2", description: "2차 화재를 대비하여 소화기를 구비하고, 화재 예방을 해주세요"),
        EarthquakeAction(imageName: "NormalAction3", description: "떨어질 수 있는 물건들을 잘 고정해주세요")
    ]
    
    static let whileActionArray: [EarthquakeAction] = [
        EarthquakeAction(imageName: "WhileAction1", description: ""),
        EarthquakeAction(imageName: "WhileAction2", description: ""),
        EarthquakeAction(imageName: "WhileAction3", description: "")
    ]
    
    static let afterActionArray: [EarthquakeAction] = [
        EarthquakeAction(imageName: "AfterAction1", description: "라디오/뉴스로 상황을 확인해주세요"),
        EarthquakeAction(imageName: "AfterAction2", description: "부상 시 응급처치를 진행해주세요"),
        EarthquakeAction(imageName: "AfterAction3", description: "가까운 대피소로 대피해주세요")
    ]
}

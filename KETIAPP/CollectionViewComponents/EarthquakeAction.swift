//
//  earthquakeAction.swift
//  KETIAPP
//
//  Created by 홍지우 on 2023/05/27.
//

import Foundation

public struct EarthquakeAction {
    let imageName: String
    let description: String
}

extension EarthquakeAction {
//    static let normalStateAction = EarthquakeAction(imageName: "YOUR_IMAGE_NAME", description: "지진이 일어나면, 책상 아래로 피하십시오.")
//    static let whileEarthquakeStateAction = EarthquakeAction(imageName: <#T##String#>, description: <#T##String#>)
//    static let afterEarthquakeStateAction = EarthquakeAction(imageName: <#T##String#>, description: <#T##String#>)
    
    static let normalStateActionArray: [EarthquakeAction] = [
        EarthquakeAction(imageName: "normalState1", description: "지진이 일어날 상황을 대비해 비상약을 준비하십시오."),
        EarthquakeAction(imageName: "normalState2", description: "지진이 일어날 상황을 대비해 탈출 경로를 미리 확보하십시오."),
        EarthquakeAction(imageName: "normalState3", description: "지진이 일어날 상황에서 2차 피해를 대비해 주변을 잘 정돈하십시오."),
    ]
    
    static let wileEarthquakeStateActionArray: [EarthquakeAction] = [
        EarthquakeAction(imageName: "whileState1", description: "지진이 일어났을 때 책상 아래로 몸을 피하십시오."),
        EarthquakeAction(imageName: "whileState2", description: "지진이 일어났을 때 차에 있다면 차를 통행을 방해하지 않는 장소에 세우고 열쇠를 꽂아둔 채 내리십시오."),
        EarthquakeAction(imageName: "whileState3", description: "지진이 일어났을 때 지하철에 있다면 손잡이나 기둥을 잡고 최대한 자세를 낮추십시오."),
    ]
    
    static let afterEarthquakeStateActionArray: [EarthquakeAction] = [
        EarthquakeAction(imageName: "afterState1", description: "지진이 일어난 후 부상이 있다면 주변 물건으로 응급조치를 하십시오."),
        EarthquakeAction(imageName: "afterState2", description: "지진이 일어난 후 대피 전 가족이 볼 수 있도록 이동할 피난소 위치를 적은 후 대피하십시오."),
        EarthquakeAction(imageName: "afterState3", description: "지진이 일어난 후 라디오, 텔레비전 뉴스로 상황을 파악하십시오."),
    ]
}

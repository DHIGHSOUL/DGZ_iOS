//
//  ViewController.swift
//  KETIAPP
//
//  Created by ROLF J. on 2023/05/12.
//

import UIKit

class KETIViewController: UIViewController {
    // 'Detect' class singletone
    let detect = Detect.sharedDetect()
    
    var earthQuake: Bool = false
    
    //  State View
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var stateImageView: UIImageView!
    @IBOutlet weak var stateLabel: UILabel!
    
    //  Location View
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var W3WLabel: UILabel!
    
    // Views
    @IBOutlet weak var magnitudeView: UIView!
    @IBOutlet weak var intensityView: UIView!
    @IBOutlet weak var actionView: UIView!
    @IBOutlet weak var informationView: UIView!
    
    // View components
    @IBOutlet weak var magnitudeLabel: UILabel!
    @IBOutlet weak var magnitudeValue: UILabel!
    @IBOutlet weak var intensityLabel: UILabel!
    @IBOutlet weak var intensityValue: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var actionImageView: UIImageView!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var informationImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detect.checkEarthquakeStatus()
        checkAndChangeMainView()
        
        hideStateLabelAndRevealStateImage()
    }
    
    //  Disappear stateLabel softly & Appear stateImageView softly
    func hideStateLabelAndRevealStateImage() {
        self.stateImageView.alpha = 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 0.3) {
                self.stateLabel.alpha = 0
                self.stateImageView.alpha = 1
            }
        }
    }
    
    //  Check and change main view
    func checkAndChangeMainView() {
        viewSetting()
        
        if earthQuake == true {
            earthquakeOccured()
        } else {
            normalState()
        }
    }
    
    //  Setting views
    func viewSetting() {
        let layerBorderColor: UIColor = BGColor()
        
        locationView.layer.borderWidth = 2
        locationView.layer.borderColor = layerBorderColor.cgColor
        locationView.layer.cornerRadius = 10
        
        magnitudeView.layer.borderWidth = 2
        magnitudeView.layer.borderColor = layerBorderColor.cgColor
        magnitudeView.layer.cornerRadius = 10
        
        intensityView.layer.borderWidth = 2
        intensityView.layer.borderColor = layerBorderColor.cgColor
        intensityView.layer.cornerRadius = 10
        
        actionView.layer.borderWidth = 2
        actionView.layer.borderColor = layerBorderColor.cgColor
        actionView.layer.cornerRadius = 10
        
        informationView.layer.borderWidth = 2
        informationView.layer.borderColor = layerBorderColor.cgColor
        informationView.layer.cornerRadius = 10
    }
    
    //  Normal state
    func normalState() {
        // StateView
        stateView.backgroundColor = .clear
        stateImageView.image = UIImage(named: "Safe")
        stateLabel.text = "안정 상태"
        
        // LocationView
        locationView.backgroundColor = .clear
        locationLabel.text = "현재 위치"
        currentLocationLabel.text = "또 다른 함수"
        W3WLabel.text = "또 다른 함수"
        
        // Views
        magnitudeLabel.text = "규모"
        magnitudeValue.text = "-"
        intensityLabel.text = "진도"
        intensityValue.text = "-"
        actionLabel.text = "행동요령"
        actionImageView.image = UIImage(systemName: "globe.central.south.asia.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(BGColor())
        informationImageView.image = UIImage(systemName: "info.bubble.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(BGColor())
    }
    
    //  If earthquake occured
    func earthquakeOccured() {
        stateImageView.image = UIImage(named: "Siren")
        stateLabel.textColor = .red
        stateLabel.text = "지진 발생!"
        
        locationLabel.text = "지진 발생 위치"
        currentLocationLabel.text = "또 다른 함수"
        W3WLabel.text = "또 다른 함수"
    }
    
    //  After earthquake
    func afterEarthquake() {
        
    }
    
    // Check the backgroundColor
    public func BGColor() -> UIColor {
        let layerBorderColor: UIColor
        if self.traitCollection.userInterfaceStyle == .dark {
            layerBorderColor = .white
        } else {
            layerBorderColor = .black
        }
        return layerBorderColor
    }
}

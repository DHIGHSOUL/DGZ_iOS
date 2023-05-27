//
//  ViewController.swift
//  KETIAPP
//
//  Created by ROLF J. on 2023/05/12.
//

import UIKit
import WebKit
import CoreLocation

class KETIViewController: UIViewController {
    // KETIViewController singletone
    private static let ketiViewController = KETIViewController()
    public static func sharedKETIViewController() -> KETIViewController {
        return KETIViewController()
    }
    
    // 'Detect' class singletone
    let detect = Detect.sharedDetect()
    
    // let detect = Detect.sharedDetect()
    var layerBorderColor: UIColor!
    
    // Timer for get sensor data every 1 sec
    let sensorTimer = MyTimer()
    
    // webView for showing kakaomap
    var kakaoMapView: WKWebView!
    
    // Earthquake state -> Manage whole application functions
    public var earthquake: EarthquakeState = .normalState
    
    // Dispath group for set location informations
    let setDispathGroup = DispatchGroup()
    
    // Global variables / Latitude, Longitude, and location
    public var latitude: String = ""
    public var latitudeDouble: Double = 0.0
    public var longitude: String = ""
    public var longitudeDouble: Double = 0.0
    public var locationAddress: String = ""
    
    // State View
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var stateImageView: UIImageView!
    @IBOutlet weak var stateLabel: UILabel!
    
    // Location View
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
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // View Click Recognizer
        let stateTappedGesture = UITapGestureRecognizer(target: self, action: #selector(stateViewTappedHandler(sender:)))
        let actionTappedGesture = UITapGestureRecognizer(target: self, action: #selector(actionViewTappedHandler(sender:)))
        let informationTappedGesture = UITapGestureRecognizer(target: self, action: #selector(informationViewTappedHandler(sender:)))
        
//        detect.checkEarthquakeStatus()
        layerBorderColor = BGColor()
        
        hideStateLabelAndRevealStateImage()
        stateView.addGestureRecognizer(stateTappedGesture)
        actionView.addGestureRecognizer(actionTappedGesture)
        informationView.addGestureRecognizer(informationTappedGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Start 'GET' sensor data
        sensorTimer.startTimer()
        sensorTimer.controlClosure = { [weak self] state in
            DispatchQueue.main.async {
                self?.earthquake = .whileEarthquake
                self?.checkAndChangeMainView()
            }
        }
        
        setLocationInformation()
        checkAndChangeMainView()
        if earthquake == .afterEarthquake {
            loadKakaomapIfAfterEarthquake()
        }
    }
    
    // Disappear stateLabel softly & Appear stateImageView softly
    func hideStateLabelAndRevealStateImage() {
        stateView.isUserInteractionEnabled = false
        self.stateImageView.alpha = 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.3) {
                self.stateLabel.alpha = 0
                self.stateImageView.alpha = 1
                self.stateView.isUserInteractionEnabled = true
            }
        }
    }
    
    // Check and change main view
    func checkAndChangeMainView() {
        viewSetting()
        
        if earthquake == .whileEarthquake {
            earthquakeOccured()
        } else if earthquake == .afterEarthquake {
            afterEarthquake()
        } else if earthquake == .normalState {
            normalState()
        }
        
        softAnimation()
    }
    
    // Setting views
    func viewSetting() {
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
    
    // Check earthquake state and change viewController
    
    
    // MARK: - Set main view for each state(.normalState, .whileEarthquake, .afterEarthquake)
    // Normal state
    func normalState() {
        // StateView
        stateView.backgroundColor = .clear
        stateImageView.image = UIImage(named: "Safe")
        stateLabel.text = "안정 상태"
        
        // LocationView
        locationView.backgroundColor = .clear
        locationLabel.text = "현재 위치"
        
        setLocationInformation()
        currentLocationLabel.text = locationAddress
        W3WLabel.text = "또 다른 함수"
        
        // Views
        magnitudeLabel.text = "규모"
        magnitudeValue.text = "-"
        intensityLabel.text = "진도"
        intensityValue.text = "-"
        actionLabel.text = "행동요령"
        actionImageView.image = UIImage(systemName: "globe.central.south.asia.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(BGColor())
        informationLabel.text = "추가정보"
        informationImageView.image = UIImage(systemName: "info.bubble.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(BGColor())
    }
    
    // If earthquake occured
    func earthquakeOccured() {
        // StateView
        stateImageView.image = UIImage(named: "Siren")
        stateLabel.textColor = .red
        stateLabel.text = "지진 발생!"
        
        // LocationView
        locationLabel.text = "지진 발생 위치"
        currentLocationLabel.text = "또 다른 함수"
        W3WLabel.text = "또 다른 함수"
        
        // Get magnitude and intensity information
        let magnitudeInformation = detect.setMagnitudeView(magnitude: 4.5)
        let magnitudeText = magnitudeInformation.0
        let magnitudeColor = magnitudeInformation.1
        
        let intensityInformation = detect.setIntensityView(intensity: 3.4)
        let intensityText = intensityInformation.0
        let intensityColor = intensityInformation.1
        
        // Views
        magnitudeView.backgroundColor = magnitudeColor
        magnitudeLabel.text = "규모"
        magnitudeValue.text = magnitudeText
        
        intensityView.backgroundColor = intensityColor
        intensityLabel.text = "예상진도"
        intensityValue.text = intensityText
        
        actionLabel.text = "행동요령"
        actionImageView.image = UIImage(systemName: "globe.central.south.asia.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(BGColor())
        
        informationLabel.text = "도달예정"
        informationImageView.image = UIImage(systemName: "info.bubble.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(BGColor())
    }
    
    //  After earthquake
    func afterEarthquake() {
        // StateView
        stateImageView.image = UIImage(named: "Exit")
        stateLabel.textColor = .green
        stateLabel.text = "대피하세요!"
        
        // LocationView
        locationLabel.text = "최단 대피경로 위치"
        currentLocationLabel.text = "또 다른 함수"
        W3WLabel.text = "또 다른 함수"
        
        // Views
        magnitudeLabel.text = "최종규모"
        magnitudeValue.text = "-"
        intensityLabel.text = "최종진도"
        intensityValue.text = "-"
        actionLabel.text = "행동요령"
        actionImageView.image = UIImage(systemName: "globe.central.south.asia.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(BGColor())
        informationLabel.text = "대피장소"
                informationImageView.image = UIImage(systemName: "info.bubble.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(BGColor())
    }
    
    // Check the backgroundColor
    func BGColor() -> UIColor {
        let layerBorderColor: UIColor
        if self.traitCollection.userInterfaceStyle == .dark {
            layerBorderColor = .white
        } else {
            layerBorderColor = .black
        }
        return layerBorderColor
    }
    
    // Get latitide and longitude from Mobius server
    func getLatAndLng(completion: @escaping (String, String) -> ()) {
        var request = URLRequest(url: URL(string: "http://203.253.128.177:7579/Mobius/zz/Map/latest")!, timeoutInterval: Double.infinity)
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
                let parts = con?.split(separator: ",")
                let lat = parts?[0]
                let lng = parts?[1]
                
                self.latitude = String(describing: lat)
                self.longitude = String(describing: lng)
                //                print("Completion lat: \(self.latitude), Completion lng: \(self.longitude)")
                completion(String(describing: lat), String(describing: lng))
            } catch {
                print("JSON Error occured")
            }
        }
        task.resume()
    }
    
    // TODO: - Get address from latitude and longitude
    // TODO: - Get W3W from latitude and longitude
    func getAddress(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        //        print("getAddressLatitudeDouble: \(self.latitudeDouble), getAddressLongitudeDouble: \(self.longitudeDouble)")
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding failed: \(error)")
                return
            }
            
            if let placemark = placemarks?.first {
                let address = "\(String(describing: placemark.administrativeArea))"
                self.locationAddress = address
                print(address)
                self.currentLocationLabel.text = address
            } else {
                print("No placemark found.")
            }
        }
    }
    
    func setLocationInformation() {
        if earthquake == .normalState {
            setDispathGroup.enter()
            getLatAndLng { lat, lng in
                let optionalLatitude: String? = lat
                let optionalLongitude: String? = lng
                
                if let optionalLatitudeString = optionalLatitude, let optionalLongitudeString = optionalLongitude {
                    let latitudeString = String(optionalLatitudeString)
                    let latitudeDouble = Double(latitudeString)
                    self.latitudeDouble = latitudeDouble ?? -1.0
                    let longitudeString = String(optionalLongitudeString)
                    let longitudeDouble = Double(longitudeString)
                    self.longitudeDouble = longitudeDouble ?? -1.0
                    print("latitudeString: \(latitudeString), longitudeString: \(longitudeString)")
                    print("latitudeDouble: \(String(describing: latitudeDouble)), longitudeDouble: \(String(describing: longitudeDouble))")
                }
                self.setDispathGroup.leave()
            }
            
            setDispathGroup.notify(queue: .main) {
                self.getAddress(latitude: self.latitudeDouble, longitude: self.longitudeDouble)
            }
        }
    }
    
    func softAnimation() {
        stateView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3) {
            self.stateLabel.alpha = 1
            self.stateImageView.alpha = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.3) {
                self.stateLabel.alpha = 0
                self.stateImageView.alpha = 1
                self.stateView.isUserInteractionEnabled = true
            }
        }
    }
    
    // MARK: - View Tab Handler
    // Animate stateView
    @objc func stateViewTappedHandler(sender: UITapGestureRecognizer) {
        softAnimation()
    }
    
    // Move to other viewController to show action between and after earthquake
    @objc func actionViewTappedHandler(sender: UITapGestureRecognizer) {
        let actionViewController = ActionViewController()
        self.present(actionViewController, animated: true, completion: nil)
    }
    
    // Move to safari for show map and information
    @objc func informationViewTappedHandler(sender: UITapGestureRecognizer) {
    }
}

// MARK: - Load web view for showing kakaomap with kakaoAPI
extension KETIViewController: WKNavigationDelegate {
    func loadKakaomapIfAfterEarthquake() {
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        self.informationLabel.removeFromSuperview()
        self.informationImageView.removeFromSuperview()
        kakaoMapView?.removeFromSuperview()
        kakaoMapView = WKWebView(frame: informationView.bounds, configuration: configuration)
        kakaoMapView.navigationDelegate = self
        kakaoMapView.layer.borderWidth = 2
        kakaoMapView.layer.borderColor = layerBorderColor.cgColor
        kakaoMapView.layer.cornerRadius = 10
        
        self.informationView.addSubview(kakaoMapView)
        
        let kakaoMapsHTML = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <title>Kakao 지도 시작하기</title>
            <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=953e52838aa6fbc43c90bddf551dcbc7"></script>
        </head>
        <body>
        <div id="map" style="width:100%;height:400px;"></div>
        <script>
        var container = document.getElementById('map');
        var options = {
            center: new kakao.maps.LatLng(37.50802, 127.062835),
            level: 3
        };
        var map = new kakao.maps.Map(container, options);
        </script>
        </body>
        </html>
        """
        kakaoMapView.loadHTMLString(kakaoMapsHTML, baseURL: URL(string: "http://dapi.kakao.com"))
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Web content loading...")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Web content loaded successfully")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Web content load fail\nError code: \(error)")
    }
}

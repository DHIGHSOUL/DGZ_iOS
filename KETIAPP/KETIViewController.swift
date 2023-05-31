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
    //  Singletone
    private static let ketiViewController = KETIViewController()
    public static func sharedKETIViewController() -> KETIViewController {
        return KETIViewController()
    }
    
    // Location manager for get currnet location(latitude and longitude)
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    // Singletones
    let detect = Detect.sharedDetect()
    let notficationManager = NotificationManager.sharedNotificationManager()
    
    var layerBorderColor: UIColor!
    
    // Timer for get sensor data every 1 sec
    let earthquakeCheckTimer = MyTimer()
    let earthquakeFinishTimer = MyTimer()
    
    // webView for showing kakaomap
    var kakaoMapView: WKWebView!
    
    // Earthquake state -> Manage whole application functions
    public var earthquake: EarthquakeState = .normalState
    
    // Dispath group for set location informations
    let setDispathGroup = DispatchGroup()
    
    // Change image to show current actions of situation
    let normalStateActions: [EarthquakeAction] = EarthquakeAction.normalActionArray
    var normalStateActionIndex: Int = 0
    let afterStateActions: [EarthquakeAction] = EarthquakeAction.afterActionArray
    var afterStateActionIndex: Int = 0
    
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
    var applicationFirstOpen: Bool = true
    
    var magnitudeValue: Float = 0.0
    @IBOutlet weak var magnitudeLabel: UILabel!
    @IBOutlet weak var magnitudeValueLabel: UILabel!
    
    var intensityValue: String = ""
    @IBOutlet weak var intensityLabel: UILabel!
    @IBOutlet weak var intensityValueLabel: UILabel!
    
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var actionClickLabel: UILabel!
    @IBOutlet weak var actionImageView: UIImageView!
    @IBOutlet weak var actionDescription: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var informationClickLabel: UILabel!
    @IBOutlet weak var informationImageView: UIImageView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManagerSetting()
        notficationManager.requestNotificationAuthorization()
        
        print("Hello, World!")
        
        // View Click Recognizer
        let stateTappedGesture = UITapGestureRecognizer(target: self, action: #selector(stateViewTappedHandler(sender:)))
        let actionTappedGesture = UITapGestureRecognizer(target: self, action: #selector(actionViewTappedHandler(sender:)))
        let informationTappedGesture = UITapGestureRecognizer(target: self, action: #selector(informationViewTappedHandler(sender:)))
        
        layerBorderColor = BGColor()
        
        hideStateLabelAndRevealStateImage()
        stateView.addGestureRecognizer(stateTappedGesture)
        actionView.addGestureRecognizer(actionTappedGesture)
        informationView.addGestureRecognizer(informationTappedGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        initializeState()
        print("Current earthquake state = \(earthquake)")
        
        //        setLocationInformation()
        checkAndChangeMainView()
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
    
    
    // MARK: - Set main view for each state(.normalState, .whileEarthquake, .afterEarthquake)
    // Normal state
    func normalState() {
        // Start 'GET' sensor data
        startCheckEarthquake()
        
        // StateView
        stateView.backgroundColor = .clear
        stateLabel.textColor = layerBorderColor
        stateImageView.image = UIImage(named: "Safe")
        stateLabel.text = "안정 상태"
        
        // LocationView
        locationView.backgroundColor = .clear
        locationLabel.text = "현재 위치"
        
        //        setLocationInformation()
        getAddress(latitude: latitudeDouble, longitude: longitudeDouble) { [weak self] address in
            DispatchQueue.main.async {
                self?.currentLocationLabel.text = address
            }
        }
        
        W3WLabel.text = "W3W GET SUCCESS, Wait for competition"
//        getW3W()
        
        // Views
        magnitudeView.backgroundColor = .clear
        magnitudeLabel.text = "규모"
        magnitudeValueLabel.text = "-"
        intensityView.backgroundColor = .clear
        intensityLabel.text = "진도"
        intensityValueLabel.text = "-"
        actionLabel.text = "대비요령"
        actionClickLabel.text = "클릭하여 넘어가기"
        actionImageView.image = UIImage(named: normalStateActions[normalStateActionIndex].imageName)
        actionDescription.text = normalStateActions[normalStateActionIndex].description
        informationLabel.text = "추가정보"
        informationClickLabel.text = "클릭하여 웹으로 이동"
        informationImageView.image = UIImage(systemName: "info.bubble.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(layerBorderColor)
    }
    
    // If earthquake occured
    func earthquakeOccured() {
        // StateView
        stateImageView.image = UIImage(named: "Siren")
        stateLabel.textColor = .red
        stateLabel.text = "지진 발생!"
        
        // LocationView
        locationLabel.text = "현재 위치"
        getAddress(latitude: latitudeDouble, longitude: longitudeDouble) { [weak self] address in
            DispatchQueue.main.async {
                self?.currentLocationLabel.text = address
            }
        }
        
        W3WLabel.text = "W3W GET SUCCESS, Wait for competition"
//        getW3W()
        
        
        // Get magnitude and intensity information
        detect.getMaxMagAndInt { arr in
            DispatchQueue.main.async {
                self.magnitudeValue = Float(arr[0]) ?? 0.0
                self.intensityValue = arr[2]
                let magnitudeInformation = self.detect.setMagnitudeView(magnitude: self.magnitudeValue)
                let magnitudeText = magnitudeInformation.0
                let magnitudeColor = magnitudeInformation.1
                
                let intensityInformation = self.detect.setIntensityView(intensity: self.intensityValue)
                let intensityText = intensityInformation.0
                let intensityColor = intensityInformation.1
                
                // Views
                self.magnitudeView.backgroundColor = magnitudeColor
                self.magnitudeLabel.text = "규모"
                self.magnitudeValueLabel.text = magnitudeText
                
                self.intensityView.backgroundColor = intensityColor
                self.intensityLabel.text = "최대 예상진도"
                self.intensityValueLabel.text = intensityText
                
                self.actionLabel.text = "행동요령"
                self.actionClickLabel.text = ""
                self.actionImageView.image = UIImage(systemName: "safari.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.red.withAlphaComponent(0.75))
                self.actionDescription.text = "클릭해주세요"
                
                self.informationLabel.text = ""
                self.informationClickLabel.text = "행동요령 탭을 클릭해주세요"
                self.informationImageView.image = UIImage(systemName: "arrow.backward")?.withRenderingMode(.alwaysOriginal).withTintColor(.red.withAlphaComponent(0.75))
            }
        }
        
        // Send my location information to Mobius platform
        self.postMyLocationToMobius()
        
        startCheckAfterEarthquake()
    }
    
    //  After earthquake
    func afterEarthquake() {
        // StateView
        stateImageView.image = UIImage(named: "Exit")
        stateLabel.textColor = .green
        stateLabel.text = "대피하세요!"
        
        // LocationView
        locationLabel.text = "현재 위치"
        getAddress(latitude: latitudeDouble, longitude: longitudeDouble) { [weak self] address in
            DispatchQueue.main.async {
                self?.currentLocationLabel.text = address
            }
        }
        
        W3WLabel.text = "W3W GET SUCCESS, Wait for competition"
//        getW3W()
        
        // Get magnitude and intensity information
        detect.getMaxMagAndInt { arr in
            DispatchQueue.main.async {
                self.magnitudeValue = Float(arr[0]) ?? 0.0
                self.intensityValue = arr[2]
                
                let magnitudeInformation = self.detect.setMagnitudeView(magnitude: self.magnitudeValue)
                let magnitudeText = magnitudeInformation.0
                let magnitudeColor = magnitudeInformation.1
                
                let intensityInformation = self.detect.setIntensityView(intensity: self.intensityValue)
                let intensityText = intensityInformation.0
                let intensityColor = intensityInformation.1
                
                // Views
                self.magnitudeView.backgroundColor = magnitudeColor
                self.magnitudeLabel.text = "최종규모"
                self.magnitudeValueLabel.text = magnitudeText
                
                self.intensityView.backgroundColor = intensityColor
                self.intensityLabel.text = "최종진도"
                self.intensityValueLabel.text = intensityText
                
                self.actionLabel.text = "행동요령"
                self.actionClickLabel.text = "클릭하여 넘어가기"
                self.actionImageView.image = UIImage(named: self.afterStateActions[self.afterStateActionIndex].imageName)
                self.actionDescription.text = self.afterStateActions[self.afterStateActionIndex].description
                
                // loadKakaomapIfAfterEarthquake()
                self.informationLabel.text = "대피장소"
                self.informationClickLabel.text = "클릭하여 웹으로 이동"
                self.informationImageView.image = UIImage(systemName: "signpost.right.and.left.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(self.layerBorderColor)
            }
        }
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
    
    func startGetCoordinates() {
        if CLLocationManager.locationServicesEnabled() {
            print("Location service on, start to get location coordinates")
            locationManager.startUpdatingLocation()
        } else {
            print("Location service off. Cannot get coordinates")
        }
    }
    
    // First initialization to set views
    func initializeState() {
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
                let earthquakeDetect: String = con ?? "N/A"
                if earthquakeDetect == "0" {
                    self.earthquake = .normalState
                    print("Initialization result = normalState")
                } else if earthquakeDetect == "1" {
                    self.earthquake = .whileEarthquake
                    print("Initialization result = whileEarthquake")
                } else if earthquakeDetect == "2" {
                    self.earthquake = .afterEarthquake
                    print("Initialization result = afterEarthquake")
                }
                print(earthquakeDetect)
            } catch {
                print("JSON Error occured")
            }
        }
        task.resume()
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
                let parts = con?.split(separator: ",")
                let lat = parts?[0]
                let lng = parts?[1]
                
                self.latitude = String(describing: lat)
                self.longitude = String(describing: lng)
                completion(String(describing: lat), String(describing: lng))
            } catch {
                print("JSON Error occured")
            }
        }
        task.resume()
    }
    
    // TODO: - Get address from latitude and longitude
    // TODO: - Get W3W from latitude and longitude
    func getAddress(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping(String?) -> ()) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        //        print("getAddressLatitudeDouble: \(self.latitudeDouble), getAddressLongitudeDouble: \(self.longitudeDouble)")
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding failed: \(error)")
                return
            }
            
            if let placemark = placemarks?.first {
                let addressArr = [ placemark.country, placemark.administrativeArea, placemark.thoroughfare, placemark.subThoroughfare ].compactMap { $0 }
                let address = addressArr.joined(separator: ", ")
                completion(address)
            } else {
                print("No placemark found.")
            }
        }
    }
    
    func getW3W(latitude: Double, longitude: Double, completion: @escaping (String?) -> ()) {
        let urlString = "https://api.what3words.com/v3/convert-to-3wa?coordinates=\(latitude)%2C\(longitude)&key=HH2N0UPZ"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to get data from URL: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data returned from URL")
                completion(nil)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = json as? [String:Any], let words = dictionary["words"] as? String {
                    completion(words)
                } else {
                    print("JSON is not a dictionary or 'words' not a string")
                    completion(nil)
                }
            } catch let error {
                print("Failed to parse JSON: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
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
    
    func startCheckEarthquake() {
        earthquakeCheckTimer.startEarthquakeCheckTimer()
        earthquakeCheckTimer.controlClosure = { [weak self] state in
            DispatchQueue.main.async {
                self?.earthquake = .whileEarthquake
                self?.checkAndChangeMainView()
                self?.startCheckAfterEarthquake()
            }
        }
    }
    
    func startCheckAfterEarthquake() {
        earthquakeFinishTimer.startEarthquakeFinishTimer()
        earthquakeFinishTimer.controlClosure = { [weak self] state in
            DispatchQueue.main.async {
                if state == .normalState {
                    self?.earthquake = .normalState
                    self?.checkAndChangeMainView()
                } else if state == .afterEarthquake {
                    self?.earthquake = .afterEarthquake
                    self?.checkAndChangeMainView()
                }
            }
        }
    }
    
    func openMapURLWithSafari() {
        var request = URLRequest(url: URL(string: "http://203.253.128.177:7579/Mobius/KETIDGZ/locationURL/latest")!, timeoutInterval: Double.infinity)
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
            print("[Location requestGET : http get 요청 성공]")
            print("Response : ", (response as? HTTPURLResponse)?.statusCode ?? 0)
            print("====================================")
            print("")
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode) else {
                print("")
                print("====================================")
                print("[Location requestGET : http get 요청 에러]")
                print("Error : ", (response as? HTTPURLResponse)?.statusCode ?? 0)
                print("====================================")
                print("")
                return
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                let jsonObject = jsonData!["m2m:cin"] as? [String:Any]
                let con = jsonObject!["con"] as? String
                let parts = con!.split(separator: "||")
                let kakaoMapURLString = String(parts[0]).trimmingCharacters(in: .whitespacesAndNewlines)
                let webMapURLString = String(parts[1]).trimmingCharacters(in: .whitespacesAndNewlines)
                
                print("kakaoMapURLString = \(kakaoMapURLString)")
//                print("webMapURLString = \(webMapURLString)")
                
                DispatchQueue.main.async {
                    let kakaoMapURL: URL? = URL(string: kakaoMapURLString)
                    let webMapURL: URL? = URL(string: webMapURLString)
                    if let url = kakaoMapURL {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            print("Cannot open kakaomap URL, Open map with web")
                            if UIApplication.shared.canOpenURL(webMapURL!) {
                                UIApplication.shared.open(webMapURL!, options: [:], completionHandler: nil)
                            } else {
                                print("Cannot open web map URL")
                            }
                        }
                    }
                }
            } catch {
                print("Fatal location get error")
            }
        }
        task.resume()
    }
    
    func postMyLocationToMobius() {
        let uploadLocationString = "\(latitudeDouble)||\(longitudeDouble)"
        
        let parameters = "{\n    \"m2m:cin\": {\n        \"con\": \"\(uploadLocationString)\"\n    }\n}"
        let postData = parameters.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: "http://203.253.128.177:7579/Mobius/KETIDGZ/mylocation")!, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("12345", forHTTPHeaderField: "X-M2M-RI")
        request.addValue("Syr7TmQ-lQz", forHTTPHeaderField: "X-M2M-Origin")
        request.addValue("application/vnd.onem2m-res+json; ty=4", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard data != nil else {
                print("Cannot POST data")
                return
            }
            
            let successRange = 200..<300
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode) else {
                print("")
                print("====================================")
                print("[Location requestPOST : http post 요청]")
                print("Error : ", (response as? HTTPURLResponse)?.statusCode ?? 0)
                print("====================================")
                print("")
                return
            }
        }
        task.resume()
    }
    
    func postMyLocationToLocal() {
        var request = URLRequest(url: URL(string: "http://192.168.0.253z:3000/earthquake/mylocation")!, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard data != nil else {
                print("Cannot send GET signal")
                return
            }
            
            let successRange = 200..<300
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode) else {
                print("")
                print("====================================")
                print("[LocalServer requestGET : http get 요청]")
                print("Error : ", (response as? HTTPURLResponse)?.statusCode ?? 0)
                print("====================================")
                print("")
                return
            }
        }
        task.resume()
    }
    
    func checkKakaoMapExisted() -> Bool {
        let kakaoMapScheme = "kakaomap:"
        let kakaoMapURL = URL(string: kakaoMapScheme)
        
        if let kakaoMapURL = kakaoMapURL {
            return UIApplication.shared.canOpenURL(kakaoMapURL)
        }
        
        return false
    }
    
    func changeNormalStateActionView() {
        if normalStateActionIndex != 0 && normalStateActionIndex % 2 == 0 {
            normalStateActionIndex = 0
        } else {
            normalStateActionIndex += 1
        }
        actionImageView.image = UIImage(named: normalStateActions[normalStateActionIndex].imageName)?.withRenderingMode(.alwaysOriginal)
        actionDescription.text = normalStateActions[normalStateActionIndex].description
    }
    
    func changeWhileStateActionView() {
        if let earthquakeURL = URL(string: "https://www.weather.go.kr/pews/man/m1.html#b2") {
            if UIApplication.shared.canOpenURL(earthquakeURL) {
                UIApplication.shared.open(earthquakeURL)
            }
        }
    }
    
    func changeAfterStateActionView() {
        if afterStateActionIndex != 0 && afterStateActionIndex % 2 == 0 {
            afterStateActionIndex = 0
        } else {
            afterStateActionIndex += 1
        }
        actionImageView.image = UIImage(named: afterStateActions[afterStateActionIndex].imageName)?.withRenderingMode(.alwaysOriginal)
        actionDescription.text = afterStateActions[afterStateActionIndex].description
    }
    
    //    func openActionViewController() {
    //        let actionViewController = ActionViewController()
    //        navigationController?.pushViewController(actionViewController, animated: true)
    //    }
    
    func openAdditionalInformationNotion() {
        if let notionURL = URL(string: "https://potent-barnacle-025.notion.site/689c9b6f4d3b4ebabc234ab52855f2ce") {
            if UIApplication.shared.canOpenURL(notionURL) {
                UIApplication.shared.open(notionURL)
            }
        }
    }
    
    func getW3W() {
        getW3W(latitude: latitudeDouble, longitude: longitudeDouble) { [weak self] W3W in
            DispatchQueue.main.async {
                self?.W3WLabel.text = W3W ?? "Invalid W3W Api Key || Overused"
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
        if earthquake == .normalState {
            changeNormalStateActionView()
        } else if earthquake == .whileEarthquake {
            changeWhileStateActionView()
        } else if earthquake == .afterEarthquake {
            changeAfterStateActionView()
        }
    }
    
    // Move to safari for show map and information
    @objc func informationViewTappedHandler(sender: UITapGestureRecognizer) {
        if earthquake == .normalState {
            openAdditionalInformationNotion()
        } else if earthquake == .afterEarthquake {
            openMapURLWithSafari()
        }
    }
}

// MARK: - Load web view for showing kakaomap with kakaoAPI
extension KETIViewController: WKNavigationDelegate {
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

extension KETIViewController: CLLocationManagerDelegate {
    func locationManagerSetting() {
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManagerDidChangeAuthorization(locationManager)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Get location as latitude and longitude")
        if let location = locations.first {
            print("Latitude : \(location.coordinate.latitude)")
            self.latitudeDouble = location.coordinate.latitude
            print("Longitude : \(location.coordinate.longitude)")
            self.longitudeDouble = location.coordinate.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location get error : \(error)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if CLLocationManager.locationServicesEnabled() {
            let authorizationStatus = CLLocationManager.authorizationStatus()
            if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
                print("위치 정보 읽기 시작")
                locationManager.startUpdatingLocation()
            } else {
                print("위치 정보를 받아올 수 없음")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied, .restricted, .notDetermined:
            print("Location access not granted!")
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            print("Fatal error : Location manager")
        }
    }
}

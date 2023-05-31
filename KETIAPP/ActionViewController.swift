////
////  ActionViewController.swift
////  KETIAPP
////
////  Created by ROLF J. on 2023/05/18.
////
//
//import UIKit
//
//class ActionViewController: UIViewController {
//    let ketiViewController = KETIViewController.sharedKETIViewController()
//    var currentEarthquakeState: EarthquakeState = .normalState
//
//    @IBOutlet weak var actionLabel: UILabel!
//    @IBOutlet weak var actionImageView: UIImageView!
//    @IBOutlet weak var pageControl: UIPageControl!
//    
//    let normalActions: [EarthquakeAction] = EarthquakeAction.normalActionArray
//    let whileActions: [EarthquakeAction] = EarthquakeAction.whileActionArray
//    let afterActions: [EarthquakeAction] = EarthquakeAction.afterActionArray
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.backgroundColor = .black
////        actionLabel.text = "행동 요령"
////        actionLabel.textColor = .white
////
////        if ketiViewController.earthquake == .normalState {
////            actionImageView.image = UIImage(named: normalActions[0].imageName)
////        } else if ketiViewController.earthquake == .whileEarthquake {
////            actionImageView.image = UIImage(named: whileActions[0].imageName)
////        } else if ketiViewController.earthquake == .afterEarthquake {
////            actionImageView.image = UIImage(named: afterActions[0].imageName)
////        }
////
////        pageControl.numberOfPages = 3
////        pageControl.currentPage = 0
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//    }
//}

//
//  ActionViewController.swift
//  KETIAPP
//
//  Created by ROLF J. on 2023/05/18.
//

//import UIKit
//
//class ActionViewController: UIViewController {
//    let ketiViewController = KETIViewController.sharedKETIViewController()
//
//    @IBOutlet weak var actionLabel: UILabel!
//    @IBOutlet weak var actionCollectionView: UICollectionView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = .white
//        }
//
//
//
//        //    func setAction() {
//        //        ketiViewController.earthquake = .normalState {
//        //
//        //        }
//        //    }
//
//
//}
//
import UIKit

class ActionViewController: UIViewController {
    let ketiViewController = KETIViewController.sharedKETIViewController()
    
    
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var actionCollectionView: UICollectionView!
    
    var currentEarthquakeState: EarthquakeState = .normalState {
        didSet {
            updateActions()
        }
    }
    
    var actions: [EarthquakeAction] = [] {
        didSet {
            actionCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Set up collection view
        actionCollectionView?.dataSource = self
        actionCollectionView?.delegate = self
        
//        // Register collection view cell
//        let cellNib = UINib(nibName: "ActionCell", bundle: nil)
//        actionCollectionView.register(cellNib, forCellWithReuseIdentifier: "ActionCell")
        
        // Set initial actions
        updateActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the title and actions label based on the current earthquake state
        switch currentEarthquakeState {
        case .normalState:
            self.title = "Normal State"
            actionLabel.text = "Actions for Normal State"
        case .whileEarthquake:
            self.title = "While Earthquake"
            actionLabel.text = "Actions for While Earthquake"
        case .afterEarthquake:
            self.title = "After Earthquake"
            actionLabel.text = "Actions for After Earthquake"
        }
    }
    
    func updateActions() {
        switch currentEarthquakeState {
        case .normalState:
            actions = EarthquakeAction.normalStateActionArray
        case .whileEarthquake:
            actions = EarthquakeAction.wileEarthquakeStateActionArray
        case .afterEarthquake:
            actions = EarthquakeAction.afterEarthquakeStateActionArray
        }
    }
}

extension ActionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActionCollectionViewCell", for: indexPath) as! ActionCollectionViewCell
        let action = actions[indexPath.item]
        cell.actionImageView.image = UIImage(named: action.imageName)
        cell.actionDescription.text = action.description
        return cell
    }
}

extension ActionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width
        let cellHeight: CGFloat = 100.0
        return CGSize(width: cellWidth, height: cellHeight)
    }
}


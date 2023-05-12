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
    
//  Compositional Layout components
    enum Section {
        case one2one
        case one2two
    }
//    typealias Item = 
    
//  Colleciton View
    @IBOutlet weak var earthquakeCollectionView: UICollectionView!
    
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
        if earthQuake == true {
            earthquakeOccured()
        } else {
            normalState()
        }
    }
    
//  Normal state
    func normalState() {
        stateView.backgroundColor = .clear
        stateImageView.image = UIImage(named: "Safe")
        stateLabel.text = "안정 상태"
        
        locationView.backgroundColor = .clear
        locationLabel.text = "현재 위치"
        currentLocationLabel.text = "또 다른 함수"
        W3WLabel.text = "또 다른 함수"
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
    
//  CompositionalLayout
//  Diffable DataSource(Presentation), Snapshot(Data), Compotistion layout(Layout)
    
    func layout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
        
    }
}


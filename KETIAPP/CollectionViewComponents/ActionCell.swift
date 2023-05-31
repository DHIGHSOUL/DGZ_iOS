//
//  actionCell.swift
//  KETIAPP
//
//  Created by ROLF J. on 2023/05/22.
//

import UIKit

class ActionCell: UICollectionViewCell {
    @IBOutlet weak var actionImageView: UIImageView!
    
    func configure(_ image: EarthquakeAction) {
        actionImageView.image = UIImage(named: image.imageName)
    }
}

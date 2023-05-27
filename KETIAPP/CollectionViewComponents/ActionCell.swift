//
//  actionCell.swift
//  KETIAPP
//
//  Created by ROLF J. on 2023/05/22.
//

import UIKit

class ActionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var actionImageView: UIImageView!
    @IBOutlet weak var actionDescription: UILabel!

    func configure(_ message: EarthquakeAction) {
        actionImageView.image = UIImage(named: message.imageName)
        actionDescription.text = message.description
    }
}

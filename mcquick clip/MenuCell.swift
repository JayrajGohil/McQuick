//
//  MenuCell.swift
//  mcquick clip
//
//  Created by Jayrajkumar Gohil on 10/15/20.
//

import UIKit

class MenuCell: UICollectionViewCell {

    @IBOutlet weak var lblMenuTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with model: MenuModel) {
        lblMenuTitle.text = model.title
    }
}

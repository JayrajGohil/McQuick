//
//  ProductCell.swift
//  mcquick clip
//
//  Created by Jayrajkumar Gohil on 10/14/20.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productCal: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productHighlightView: UIView!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }
        
    public func configure(with model: ProductModel) {
        productImage.image = model.image
        productTitle.text = model.title
        productCal.text = "$" + model.price + "   " + model.calories + " Cal."
    }
    

}

//
//  ItemCollectionViewCell.swift
//  Fastfood Cashier
//
//  Created by Нуржан Керимбеков on 2021-11-05.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {

    var delegate:minusDelegate?
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var qtyTextfield: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    
    var item = Item()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myImageView.makeCircle()
        myView.layer.cornerRadius = 12
        minusButton.makeCircle()
        myView.makeMiniShadow()
    }

    @IBAction func minusTapped(_ sender: Any) {
        delegate?.minusTap(item: item,cell: self)
    }
}

protocol minusDelegate {
    func minusTap(item:Item,cell:ItemCollectionViewCell)
}

//
//  CategoryTableViewCell.swift
//  Fastfood Cashier
//
//  Created by Нуржан Керимбеков on 2021-11-08.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var colorImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        colorImageView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

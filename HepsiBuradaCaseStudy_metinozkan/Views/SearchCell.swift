//
//  SearchCell.swift
//  HepsiBuradaCaseStudy_metinozkan
//
//  Created by Metin özkan on 28.10.2021.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

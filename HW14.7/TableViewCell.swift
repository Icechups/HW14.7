//
//  TableViewCell.swift
//  HW12.6
//
//  Created by Илья Перевозкин on 12.08.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var nameCharacterLabel: UILabel!
    @IBOutlet var statusImage: UIImageView!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

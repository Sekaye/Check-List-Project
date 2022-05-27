//
//  ToDoTableViewCell.swift
//  ToDoeyProject
//
//  Created by Sekaye Knutson on 5/23/22.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkImage.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

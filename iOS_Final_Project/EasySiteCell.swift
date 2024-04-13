//
//  EasySiteCell.swift
//  iOS_Final_Project
//
//  Created by Harry Nguyen on 2024-04-11.
//

import UIKit

class EasySiteCell: UITableViewCell {

    @IBOutlet var primaryLabel: UILabel!
    @IBOutlet var secondaryLabel: UILabel!
    @IBOutlet var thirdLabel: UILabel!
    @IBOutlet var fourLabel: UILabel!
    @IBOutlet var fifthLabel: UILabel!
    
    @IBOutlet var profileImg: UIImageView!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Adjust frames of labels and image view
        primaryLabel.frame = CGRect(x: 100, y: 5, width: 460, height: 30)
        secondaryLabel.frame = CGRect(x: 100, y: 30, width: 460, height: 30)
        thirdLabel.frame = CGRect(x: 100, y: 50, width: 460, height: 30)
        fourLabel.frame = CGRect(x: 100, y: 70, width: 460, height: 30)
       
  
        profileImg.frame = CGRect(x: 20, y: 20, width: 70, height: 70)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

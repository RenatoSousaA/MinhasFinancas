//
//  BankTableViewCell.swift
//  MyBank
//
//  Created by Renato Sousa on 29/02/20.
//  Copyright © 2020 Renato Sousa. All rights reserved.
//

import UIKit

class BankTableViewCell: UITableViewCell {
    @IBOutlet weak var lbBank: UILabel!
    @IBOutlet weak var ivBank: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func prepare(with banco: Bancos) {
        lbBank.text = banco.name
        
        if let image = banco.image as? UIImage {
            ivBank.image = image
        } else {
            ivBank.image = UIImage(named: "noBank")
        }
    }

}

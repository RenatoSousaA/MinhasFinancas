//
//  BankViewControllerCell.swift
//  MyBank
//
//  Created by Renato Sousa on 29/02/20.
//  Copyright © 2020 Renato Sousa. All rights reserved.
//

import Foundation

class BankTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func prepare(with conta: Bancos) {
        lbBank.text = conta.banco?.name
        
        if let image = conta.banco?.image as? UIImage {
            ivBanco.image = image
        } else {
            ivBanco.image = UIImage(named: "noBank")
        }
    }

}

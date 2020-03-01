//
//  ContasTableViewCell.swift
//  MyBank
//
//  Created by Renato Sousa on 29/02/20.
//  Copyright © 2020 Renato Sousa. All rights reserved.
//

import UIKit

class ContasTableViewCell: UITableViewCell {
    @IBOutlet weak var ivBanco: UIImageView!
    @IBOutlet weak var lbBank: UILabel!
    @IBOutlet weak var lbAgencia: UILabel!
    @IBOutlet weak var lbConta: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func prepare(with conta: Contas) {
        lbBank.text = conta.banco?.name
        lbAgencia.text = "Ag: \(conta.agencia!)"
        lbConta.text = "Cc: \(conta.conta!)"
        
        if let image = conta.banco?.image as? UIImage {
            ivBanco.image = image
        } else {
            ivBanco.image = UIImage(named: "noBank")
        }
    }

}

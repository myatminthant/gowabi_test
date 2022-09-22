//
//  ServiceCell.swift
//  gowabi_test
//
//  Created by Francis Myat on 9/22/22.
//

import UIKit

class ServiceCell: UITableViewCell {

    @IBOutlet weak var serviceNameLabel : UILabel!
    @IBOutlet weak var servicePriceLabel: UILabel!
    
    public var currency: Currency!
    public var cellService: Service! {
        didSet {
            self.serviceNameLabel.text = cellService.name
            self.servicePriceLabel.text = "\(cellService.price ?? 0) \(currency.label ?? "")"
        }
    } 
}

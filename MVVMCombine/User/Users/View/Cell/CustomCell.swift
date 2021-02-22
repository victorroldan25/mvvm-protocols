//
//  CustomCell.swift
//  MVVMCombine
//
//  Created by Victor Roldan on 3/02/21.
//

import UIKit

protocol CellCustomDelegate {
    func didTapCell(modelSelected: UserDataToPrint)
}

class CustomCell: UITableViewCell {
    @IBOutlet weak var nameLabelString  : UILabel!
    @IBOutlet weak var emailLabelString : UILabel!
    @IBOutlet weak var phoneLabelString : UILabel!
    @IBOutlet weak var updateButton     : UIButton!
    
    var delegate                        : CellCustomDelegate?
    private var cellModel               : UserDataToPrint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateButton.addTarget(self, action: #selector(tapMePressed), for: .touchUpInside)
    }

    
    func configCell(userData : UserDataToPrint){
        cellModel = userData
        self.nameLabelString.text  = userData.name
        self.emailLabelString.text = userData.email
        self.phoneLabelString.text = userData.phone
    }
    
    @objc func tapMePressed() {
        delegate?.didTapCell(modelSelected : self.cellModel)
    }
}

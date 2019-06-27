//
//  SearchingCell.swift
//  GitHubDemo
//
//  Created by Macbook on 6/23/19.
//  Copyright © 2019 QueNguyen. All rights reserved.
//

import UIKit
import RxSwift

class SearchingCell: UITableViewCell {

    @IBOutlet weak var repositoryLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    var onCheckClick: (() -> Void)?
    
    var model: Repository? {
        didSet {
            guard let repo = model else {
                return
            }
            repositoryLabel.text = repo.fullname
            checkButton.setImage(repo.isMarked ? UIImage(named: "checked") : UIImage(named: "uncheck"), for: .normal)
        }
    }
    
    @IBAction func onCheckClick(_ sender: Any) {
        onCheckClick?()
    }

    
}

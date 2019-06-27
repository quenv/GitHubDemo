//
//  NormalCell.swift
//  GitHubDemo
//
//  Created by Macbook on 6/23/19.
//  Copyright © 2019 QueNguyen. All rights reserved.
//

import UIKit

class NormalCell: UITableViewCell {

    @IBOutlet weak var repositoryLabel: UILabel!
    
    var model: Repository? {
        didSet {
            guard let repo = model else {
                return
            }
            repositoryLabel.text = repo.fullname
        }
    }
    
}

//
//  UITableView+Extension.swift
//  GitHubDemo
//
//  Created by SmartOSC on 6/26/19.
//  Copyright © 2019 QueNguyen. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {

    func registerNib(_ cellName: String){
        self.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
    }
    
    func deselectSelectedRow() {
        if let selectedIndexPaths = self.indexPathsForSelectedRows {
            selectedIndexPaths.forEach({ (indexPath) in
                self.deselectRow(at: indexPath, animated: false)
            })
        }
    }
}


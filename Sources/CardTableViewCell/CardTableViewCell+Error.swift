//
//  CardTableViewCell+Error.swift
//  
//
//  Created by Rakesha Shastri on 14/04/20.
//

import Foundation

/// Card Cell Error
enum CardCellError: Error {
    // indexPath doesn't belong to the tableView being used.
    case tableViewAndIndexPathNotInSync
}

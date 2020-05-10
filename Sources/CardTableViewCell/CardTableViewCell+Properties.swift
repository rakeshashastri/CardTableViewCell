//
//  CardTableViewCell+Properties.swift
//
//
//  Created by Rakesha Shastri on 14/04/20.
//

import UIKit

/// Card cell properties.
public struct CardCellProperties {
    public var cornerRadius: CGFloat
    public var cardBackgroundColor: UIColor
    
    // Shadow properties
    public var shadowColor: UIColor
    public var shadowRadius: CGFloat
    public var shadowOffset: CGSize
    public var shadowOpacity: Float
    
    // Separator Properties
    public var showSeparator: Bool
    public var separatorColor: UIColor
    public var separatorThickness: CGFloat
    public var separatorLeadingPadding: CGFloat
    public var separatorTrailingPadding: CGFloat
    
    // Padding variables
    public var cardTopPadding: CGFloat
    public var cardBottomPadding: CGFloat
    public var cardLeadingPadding: CGFloat
    public var cardTrailingPadding: CGFloat
}

/// Cell type which identifies the position of the cell in the section
public enum CellType {
    case top
    case normal
    case bottom
    case single
}

//
//  CardTableViewCell.swift
//  ZohoCampaigns
//
//  Created by Rakesha Shastri on 18/04/19.
//  Copyright © 2019 Zoho Corp. All rights reserved.
//

import UIKit

open class CardTableViewCell: UITableViewCell {

    //MARK: Reuse ID
    open class var identifier: String {
        return debugDescription()
    }
    
    //MARK: UI Element(s)
    public lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var shadowLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.shadowOpacity = properties.shadowOpacity
        shapeLayer.shadowRadius = properties.shadowRadius
        shapeLayer.shadowOffset = properties.shadowOffset
        shapeLayer.fillColor = UIColor.clear.cgColor
        return shapeLayer
    }()
    
    //MARK: Data Element(s)
    public var properties: CardCellProperties!
    private var cellType: CellType = .normal
    
    //MARK: Initializer(s)
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setDefaultCardProperties()
        addProperties()
        addSubviews()
        addConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helper Method(s)
    private func setDefaultCardProperties() {
        properties = CardCellProperties(
            cornerRadius: 8,
            cardBackgroundColor: .white,
            shadowColor: #colorLiteral(red:0.75, green:0.76, blue:0.83, alpha:0.50),
            shadowRadius: 8,
            shadowOffset: CGSize(width: 0, height: 2),
            shadowOpacity: 1,
            showSeparator: false,
            separatorColor: #colorLiteral(red:0.91, green:0.91, blue:0.91, alpha:1.0),
            separatorThickness: 1,
            separatorLeadingPadding: 8,
            separatorTrailingPadding: -8,
            cardTopPadding: 16,
            cardBottomPadding: -16,
            cardLeadingPadding: 16,
            cardTrailingPadding: -16
        )
    }
    
    open func addProperties() {
        updateCardProperties()
        
        selectionStyle = .none
        
        containerView.layer.cornerRadius = properties.cornerRadius
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = properties.cardBackgroundColor
        separatorView.backgroundColor = properties.separatorColor
        
        // Override and call super to add custom subview properties
    }
    
    open func updateCardProperties() {
        // To be overriden in subclass for customization of properties if needed
    }
    
    open func addSubviews() {
        contentView.addSubview(containerView)
        contentView.layer.insertSublayer(shadowLayer, at: 0)
        
        //Override and call super to add custom subviews
    }
    
    lazy var topConstraint = containerView.topAnchor.constraint(equalTo: contentView.topAnchor)
    lazy var bottomConstraint = containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    
    open func addConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: properties.separatorLeadingPadding),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: properties.separatorTrailingPadding),
            topConstraint, bottomConstraint
        ])
        // Override and call super to add custom view constraints
    }
    
    lazy var separatorLeadingConstraint = separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
    lazy var separatorTrailingConstraint = separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
    private lazy var separatorConstraints: [NSLayoutConstraint] = {
        var constraints: [NSLayoutConstraint] = []
        constraints.append(contentsOf: [
            separatorLeadingConstraint,
            separatorTrailingConstraint,
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        return constraints
    }()
    
    /// Updates the card's corners and adds a separator if necessary, based on the indexPath and tableView instances provided to the cell
    /// - Parameters:
    ///   - tableView: tableView in which the cell is being used
    ///   - indexPath: indexPath of the cell
    public func update(tableView: UITableView, indexPath: IndexPath) {
        let result = identifyRowType(for: tableView, with: indexPath)
        switch result {
        case .success(let type):
            cellType = type
        case .failure(let error):
            switch error {
            case .tableViewAndIndexPathNotInSync:
                assertionFailure("IndexPath and UITableView instances not in sync.")
            }
        }
        
        let topPadding = (cellType == .top ? properties.cardTopPadding : 0) // Top padding for the first cell or if it's the only cell
        let bottomPadding = (cellType == .bottom ? properties.cardBottomPadding : 0) // Bottom padding for the last cell or if it's the only cell
        topConstraint.constant = topPadding
        bottomConstraint.constant = bottomPadding
        
        if cellType != .bottom && properties.showSeparator {
            addSeparator()
            separatorLeadingConstraint.constant = properties.separatorLeadingPadding
            separatorTrailingConstraint.constant = properties.separatorTrailingPadding
        }
        setNeedsLayout()
    }
    
    private func identifyRowType(for tableView: UITableView, with indexPath: IndexPath) -> Result<CellType, CardCellError> {
        let lastRow = tableView.numberOfRows(inSection: indexPath.section) - 1
        if tableView.numberOfRows(inSection: indexPath.section) == 1 {
            return .success(.single)
        } else {
            switch indexPath.row {
            case 0:
                return .success(.top)
            case 1..<lastRow:
                return .success(.normal)
            case lastRow:
                return .success(.bottom)
            default:
                // How the f**k did you end up here!? All the cases have been covered already! @_@
                // You shouldn't be getting this error if you passed the indexPath and tableView from the cellForRowAt delegate. What did you this time... ¯\_(ツ)_/¯
                return .failure(.tableViewAndIndexPathNotInSync)
            }
        }
    }
    
    private func addSeparator() {
        addSubview(separatorView)
        NSLayoutConstraint.activate(separatorConstraints)
    }
    
    lazy var maskLayer = CAShapeLayer()
    
    open override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        shadowLayer.shadowColor = properties.shadowColor.cgColor
        
        // Top cell is masked at the bottom, intermediate cell at the top and bottom, bottom cell is masked at the top of the contentView. The shadows are stretched at the relevant edges, so that they don't appear faded when they are masked.
        var maskRect: CGRect = contentView.frame
        switch cellType {
        case .top:
            containerView.layer.cornerRadius = properties.cornerRadius
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            let rect = containerView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0))
            let cornerRadii = CGSize(width: properties.shadowRadius, height: properties.shadowRadius)
            shadowLayer.path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: cornerRadii).cgPath
            let maskInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
            maskRect = contentView.frame.inset(by: maskInset)
        case .normal:
            containerView.layer.cornerRadius = 0
            shadowLayer.path = UIBezierPath(roundedRect: containerView.frame.insetBy(dx: 0, dy: -20), byRoundingCorners: [], cornerRadii: .zero).cgPath
            shadowLayer.shadowOffset = .zero
        case .bottom:
            containerView.layer.cornerRadius = properties.cornerRadius
            containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            let rect = containerView.frame.inset(by: UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0))
            let cornerRadii = CGSize(width: properties.shadowRadius, height: properties.shadowRadius)
            shadowLayer.path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: cornerRadii).cgPath
            let maskInset = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
            maskRect = contentView.frame.inset(by: maskInset)
        case .single:
            containerView.layer.cornerRadius = properties.cornerRadius
            shadowLayer.path = UIBezierPath(roundedRect: containerView.frame, cornerRadius: properties.cornerRadius).cgPath
            shadowLayer.shadowPath = shadowLayer.path
        }
        shadowLayer.shadowPath = shadowLayer.path
        maskLayer.path = UIBezierPath(rect: maskRect).cgPath
        shadowLayer.mask = maskLayer
    }
    
    //MARK: Reuse
    override open func prepareForReuse() {
        super.prepareForReuse()
        
        //Removing rounded corners
        containerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        cellType = .normal
        NSLayoutConstraint.deactivate(separatorConstraints)
    }
    
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            shadowLayer.shadowColor = properties.shadowColor.cgColor
        }
    }
    
}

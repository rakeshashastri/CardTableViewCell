//
//  DefaultCardTableViewCell.swift
//  
//
//  Created by Rakesha Shastri on 14/04/20.
//

import UIKit

open class DefaultCardTableViewCell: CardTableViewCell {
    
    //MARK: UI Element(s)
    public lazy var primaryTextLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var secondaryTextLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [primaryTextLabel, secondaryTextLabel])
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    public lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var defaultShadowColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
                } else {
                    return #colorLiteral(red:0.75, green:0.76, blue:0.83, alpha:0.50)
                }
            }
        } else {
            return #colorLiteral(red:0.75, green:0.76, blue:0.83, alpha:0.50)
        }
    }
    
    override open func updateCardProperties() {
        properties.cornerRadius = 8
        
        // Shadow properties
        properties.shadowColor = defaultShadowColor
        properties.shadowRadius = 8
        properties.shadowOffset = CGSize(width: 0, height: 2)
        properties.shadowOpacity = 1
        
        // Separator Properties
        properties.showSeparator = false
        if #available(iOS 13.0, *) {
            properties.separatorColor = .separator
        } else {
            properties.separatorColor = #colorLiteral(red:0.91, green:0.91, blue:0.91, alpha:1.0)
        }
        properties.separatorThickness = 1
        
        // Padding variables
        properties.cardLeadingPadding = 16
        properties.cardTrailingPadding = 16
        properties.cardTopPadding = 16
        properties.cardBottomPadding = -16
    }
    
    override open func addProperties() {
        super.addProperties()
        
        if #available(iOS 13.0, *) {
            backgroundColor = .clear
            containerView.backgroundColor = .secondarySystemBackground
            primaryTextLabel.textColor = .label
            secondaryTextLabel.textColor = .secondaryLabel
        } else {
            backgroundColor = .clear
            containerView.backgroundColor = .white
            primaryTextLabel.textColor = .black
            secondaryTextLabel.textColor = .darkGray
        }
    }
    
    override open func addSubviews() {
        super.addSubviews()
        
        containerView.addSubview(labelStackView)
        containerView.addSubview(rightImageView)
    }
    
    //MARK: Padding Variable(s)
    let padding: CGFloat = 16
    
    override open func addConstraints() {
        super.addConstraints()
        
        //Low priority image view size constraints to avoid ambiguity in case the user does not use the image view.
        let imageViewHeightConstraint = rightImageView.heightAnchor.constraint(equalToConstant: 10)
        imageViewHeightConstraint.priority = .defaultLow
        let imageViewWidthConstraint = rightImageView.widthAnchor.constraint(equalToConstant: 10)
        imageViewWidthConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            labelStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            labelStackView.trailingAnchor.constraint(lessThanOrEqualTo: rightImageView.leadingAnchor, constant: -padding),
            labelStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            labelStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            
            rightImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            rightImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            rightImageView.heightAnchor.constraint(equalToConstant: 10),
            imageViewHeightConstraint,
            imageViewWidthConstraint
        ])
    }
    
}

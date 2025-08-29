//
//  BubbleCell.swift
//  Simple
//
//  Created by Himanshu vyas on 28/08/25.
//

import Foundation
import UIKit


class ChatBubbleCell: UITableViewCell {
    
    private let bubbleView = UIView()
    private let messageLabel = UILabel()
    private let messageImageView = UIImageView()
    
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear        // cell background
        contentView.backgroundColor = .clear
        setupViews()
    }
    
    // 🔑 Reset cell before reuse
        override func prepareForReuse() {
            super.prepareForReuse()
            messageLabel.text = nil
            messageLabel.isHidden = true
            messageImageView.image = nil
            messageImageView.isHidden = true
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        selectionStyle = .none
        
        bubbleView.layer.cornerRadius = 16
        bubbleView.layer.masksToBounds = true
        contentView.addSubview(bubbleView)
        
        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 16)
        bubbleView.addSubview(messageLabel)
        
        messageImageView.contentMode = .scaleAspectFill
        messageImageView.layer.cornerRadius = 12
        messageImageView.layer.masksToBounds = true
        messageImageView.isHidden = true
        bubbleView.addSubview(messageImageView)
        
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Bubble constraints
        leadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        trailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.7),
            
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -8),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),
            
            messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8),
            messageImageView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -8),
            messageImageView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 8),
            messageImageView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -8),
            messageImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 200)
        ])
    }
    
    func configure(with message: Message) {
        // Reset content
          messageLabel.text = nil
          messageImageView.image = nil
        switch message.type {
        case .text(let text):
            messageLabel.text = text
            messageLabel.isHidden = false
            messageImageView.isHidden = true
        case .image(let image):
            messageImageView.image = image
            messageImageView.isHidden = false
            messageLabel.isHidden = true
        case .typing:
            messageLabel.text = "..."
            //messageLabel.font = .systemFont(ofSize: 24, weight: .bold)
            messageLabel.isHidden = false
        }
        
        // Force layout refresh
           setNeedsLayout()
           layoutIfNeeded()
           
        
        if message.isUser {
            bubbleView.backgroundColor = UIColor.darkGray
            messageLabel.textColor = .white
            trailingConstraint.isActive = true
            leadingConstraint.isActive = false
        } else {
            bubbleView.backgroundColor = UIColor(white: 0.9, alpha: 1)
            messageLabel.textColor = .black
            trailingConstraint.isActive = false
            leadingConstraint.isActive = true
        }
    }
}


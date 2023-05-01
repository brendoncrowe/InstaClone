//
//  FlexibleTextView.swift
//  InstaClone
//
//  Created by Brendon Crowe on 5/1/23.
//

import UIKit

class FlexibleTextView: UITextView {
    // limit the height of expansion per intrinsicContentSize
    var maxHeight: CGFloat = 0.0
    public let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.text = "enter comment"
        label.textColor = UIColor.gray
        return label
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        isScrollEnabled = false
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        NotificationCenter.default.addObserver(self, selector: #selector(UITextInputDelegate.textDidChange(_:)), name: UITextView.textDidChangeNotification, object: self)
        addSubview(placeHolderLabel)
        
        NSLayoutConstraint.activate([
            placeHolderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            placeHolderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            placeHolderLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            placeHolderLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var text: String! {
        didSet {
            invalidateIntrinsicContentSize()
            placeHolderLabel.isHidden = !text.isEmpty
        }
    }
    
    override var font: UIFont? {
        didSet {
            placeHolderLabel.font = font
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        
        if size.height == UIView.noIntrinsicMetric {
            // force layout
            layoutManager.glyphRange(for: textContainer)
            size.height = layoutManager.usedRect(for: textContainer).height + textContainerInset.top + textContainerInset.bottom
        }
        
        if maxHeight > 0.0 && size.height > maxHeight {
            size.height = maxHeight
            
            if !isScrollEnabled {
                isScrollEnabled = true
            }
        } else if isScrollEnabled {
            isScrollEnabled = false
        }
        
        return size
    }
    
    @objc private func textDidChange(_ note: Notification) {
        // needed incase isScrollEnabled is set to true which stops automatically calling invalidateIntrinsicContentSize()
        invalidateIntrinsicContentSize()
        placeHolderLabel.isHidden = !text.isEmpty
    }
}


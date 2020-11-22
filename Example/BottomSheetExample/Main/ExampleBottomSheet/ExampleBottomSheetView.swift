//
//  ExampleBottomSheetView.swift
//  BottomSheetExample
//
//  Created by Gaetano Matonti on 22/11/20.
//

import UIKit

final class ExampleBottomSheetView: UIView {
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "BottomSheet"
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .darkText
        label.numberOfLines = 0
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "BottomSheet is a component made with UIKit and completely written in Swift\n🧡"
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .darkText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemOrange
        button.setTitle("Download", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.setTitleColor(.white, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        button.layer.cornerRadius = 8
        return button
    }()
    
    lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [label, descriptionLabel, button])
        stack.axis = .vertical
        stack.spacing = 16
        stack.setCustomSpacing(24, after: descriptionLabel)
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(contentStack)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setConstraints() {
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}

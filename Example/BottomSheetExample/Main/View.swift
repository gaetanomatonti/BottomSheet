//
//  View.swift
//  BottomSheetExample
//
//  Created by Gaetano Matonti on 22/11/20.
//

import UIKit

final class View: UIView {
        
    lazy var sheetSizingStylePicker: UISegmentedControl = {
        let control = UISegmentedControl()
        return control
    }()
    
    lazy var handleStylePicker: UISegmentedControl = {
        let control = UISegmentedControl()
        return control
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Press me", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [sheetSizingStylePicker, handleStylePicker, button])
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(contentStack)
                
        backgroundColor = .systemGroupedBackground
        
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func populateSegmentedControl<I: Item>(picker: KeyPath<View, UISegmentedControl>, with items: [I]) {
        self[keyPath: picker].removeAllSegments()
        
        items.enumerated().forEach { index, item in
            self[keyPath: picker].insertSegment(withTitle: item.title, at: index, animated: false)
        }
        
        self[keyPath: picker].selectedSegmentIndex = 0
    }
    
}



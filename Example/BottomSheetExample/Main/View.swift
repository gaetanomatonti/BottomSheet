//
//  View.swift
//  BottomSheetExample
//
//  Created by Gaetano Matonti on 22/11/20.
//

import UIKit

final class View: UIView {
  
  // MARK: - UI Elements
  
  lazy var sheetSizingStylePicker = UISegmentedControl()
  
  lazy var handleStylePicker = UISegmentedControl()
  
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
  
  // MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    setup()
    style()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    setup()
    style()
  }
  
  // MARK: - SSUL
  
  private func setup() {
    addSubview(contentStack)
    
    contentStack.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      contentStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      contentStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
      contentStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
      contentStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  private func style() {
    View.styleView(self)
  }
  
  // MARK: - Functions
  
  func populateSegmentedControl<I: Item>(picker: KeyPath<View, UISegmentedControl>, with items: [I]) {
    self[keyPath: picker].removeAllSegments()
    
    items.enumerated().forEach { index, item in
      self[keyPath: picker].insertSegment(withTitle: item.title, at: index, animated: false)
    }
    
    self[keyPath: picker].selectedSegmentIndex = 0
  }
}

// MARK: - Styling Functions

private extension View {
  static func styleView(_ view: View) {
    if #available(iOS 13.0, *) {
      view.backgroundColor = .systemGroupedBackground
    } else {
      view.backgroundColor = .groupTableViewBackground
    }
  }
}
